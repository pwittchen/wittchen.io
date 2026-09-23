---
title: "jrs: a JVM build system written in Rust"
date: 2026-09-23 08:00:00
tags:
- java
- rust
- gradle
- open-source
---

<img src="/posts/2026/jrs/jrs_logo.png" alt="jrs logo" width="180" style="border: none;">

[jrs](https://github.com/pwittchen/jrs) is a build system for the JVM, written in Rust. It builds, tests, runs and packages a single-module Java project from one `jrs.toml` manifest and resolves dependencies from Maven Central. Kotlin, Scala and Groovy sources compile alongside the Java ones.

What I wanted is the ergonomics of Cargo: a small manifest, a committed lockfile, one binary and no build script to write. Anyone who has written Rust for a while and then comes back to a Java project knows the feeling - you just want to type `run`, and instead you're reading a `build.gradle.kts` full of plugin blocks, or an XML file that is mostly boilerplate.

Website with docs: [getjrs.dev](https://getjrs.dev).

## What it looks like

A whole project is one manifest and a source tree:

```toml
[project]
name = "my-app"
version = "1.0.0"
main-class = "com.example.Main"

[java]
source = 21

[dependencies]
"com.google.guava:guava" = "33.0.0-jre"

[dev-dependencies]
"org.junit.jupiter:junit-jupiter" = "5.10.2"
```

and the everyday commands look familiar to anyone who used Cargo:

```
jrs init            # scaffold jrs.toml, a starter main class and its test
jrs run             # compile and run
jrs test            # compile the tests and run them
jrs package --fat   # build a self-contained jar
```

There's also `jrs add` / `jrs remove`, `jrs tree --why <artifact>`, `jrs outdated`, `jrs classpath` for editors, `--watch` mode, `--offline` mode and shell completions.

The success criterion from the design spec is simple: a developer can clone a Java project containing only `src/` and `jrs.toml`, run `jrs run`, and get a working program with dependencies downloaded and linked - with no JDK-specific flags typed by hand.

## A driver, not a reimplementation

jrs doesn't reimplement the Java toolchain. It reads the manifest, resolves a dependency graph from Maven repositories and then shells out to the JDK's own tools: `javac`, `java`, `javadoc`, `jdeps`, `jlink`, `jpackage`. The Kotlin, Scala and Groovy compilers are Java programs, so they're resolved like any other dependency - each in its own isolated graph, so the Kotlin compiler's `kotlinx-coroutines` never mediates against the project's - and run on the project's JDK.

```
                         ┌──────────────────────────────────────────┐
  jrs.toml ─────────────►│                   jrs                    │
  jrs.lock ◄────────────►│                                          │
  config.toml ──────────►│  manifest → resolve → compile → package  │
                         │                 │          │        │    │
                         └─────────────────┼──────────┼────────┼────┘
                                           │          │        │
               ┌───────────────────────────┘          │        │
               ▼                                      ▼        ▼
   ┌───────────────────────┐       ┌───────────────────────────────────────┐
   │ Maven repositories    │       │ The JDK (subprocesses)                │
   │  • [repositories] …   │       │  javac · java · javadoc               │
   │  • Maven Central last │       │  jdeps · jlink · jpackage             │
   │  • file:// in tests   │       │  kotlinc/scalac/groovyc (java @file)  │
   └──────────┬────────────┘       │  java … ConsoleLauncher (JUnit)       │
              ▼                    └───────────────────────────────────────┘
   ┌───────────────────────┐
   │ shared artifact cache │   Maven layout, atomic writes,
   │ (~/.cache/jrs, …)     │   checksum-verified
   └───────────────────────┘
```

Everything lives in a library crate and `main.rs` is just a call to `jrs::cli::main()`, so every phase can be driven from a test without spawning the binary.

## Dependency resolution

This is the part that took the most care. jrs walks the graph breadth-first, level by level, and fetches each level's POMs in parallel on a `rayon` pool. For every POM it builds the effective model - parent chain, BOM imports, properties, `<dependencyManagement>` - and conflicts are mediated Maven-style: nearest wins, ties broken by declaration order, with a warning when versions differ.

A few deliberate choices:

- **Version ranges are an error**, never guessed at.
- **The classpath is deterministic** - direct dependencies first, then transitive ones, each sorted by coordinate.
- **`jrs.lock` is committed** and records coordinates and checksums, never absolute paths. As long as the manifest checksum matches, the graph comes from the lockfile and the network is only used to download missing jars, which are verified against the pinned checksums.
- **The cache mirrors the Maven repository layout**, so a path from an error message can be inspected with plain `ls`. Writes are atomic: a temp file in the destination directory, then a rename.
- **Credentials, proxies and mirrors live in the user's `config.toml`**, never in `jrs.toml`, so they don't end up in the repository.

BOMs are supported through a `[managed]` table, which is how a Spring Boot project gets its versions.

## Incremental compilation

A Java-only compile unit keeps an index of each source's hash, the classes it compiled to, each class's API digest and what it refers to. On the next build only changed sources are recompiled. If a class's API stays the same, that's it; if it changes, every source that refers to it (transitively, through subclasses too) gets recompiled. Compile-time constants are the one catch - `javac` inlines them, so they leave no reference behind - and a changed constant triggers a full rebuild of the unit. Tests aren't recompiled for a main change that leaves the main classes' API alone.

Mixed-language units are compiled whole. For Kotlin and Scala the foreign compiler goes first and reads the `.java` files for symbols, then `javac` runs with its output on the classpath; Groovy does joint compilation by running `javac` itself.

## Tests and packaging

Tests run on JUnit 4, 5 and 6, Spock, Kotest, ScalaTest and MUnit, with parallel test JVMs, retries, reports and JaCoCo coverage.

Packaging turned out to be a long list of flags, because a "jar" means different things to different people:

- `jrs package` - a thin jar whose `Class-Path` points at the cached dependencies
- `--portable` - dependencies copied into `target/lib/`
- `--fat` - everything unpacked into a single jar
- `--dist` - a zip with launch scripts
- `--jlink` / `--jpackage` - a trimmed Java runtime image or a native installer (`dmg`, `deb`, `msi`, ...)
- `--native-image` - a GraalVM native executable
- `--obfuscate` - ProGuard

## No plugins, but tasks

There is no plugin system and no build DSL - on purpose. What a project needs beyond the built-in phases goes into `[tasks]`: commands jrs runs as subprocesses, attached to fixed lifecycle points through `[hooks]` (`pre-compile`, `post-compile`, `pre-run`, ...). A task can use Java tools from Maven Central, which are resolved and pinned in `jrs.lock` like everything else. Tasks can't replace, remove or reorder the built-in phases, and no user code ever runs inside jrs. It's less powerful than Gradle, and that is the point: the build stays predictable.

## Migrating from Maven and Gradle

`jrs migrate` reads a `pom.xml` or a Gradle build (Groovy or Kotlin DSL) and writes `jrs.toml`, leaving the original untouched. It's a one-shot, best-effort translation that ends with a report in three blocks: what was migrated, what needs review and what was skipped, each with a reason.

Gradle is the hard part, because a Gradle build is a program, not data. jrs doesn't run Gradle - it reads the declarative subset of the script by pattern and says so. Version variables (`ext`, `val`, `extra`, `gradle.properties`) are inlined when they're assigned once to a literal. `Exec` and `JavaExec` tasks become `[tasks]`, `dependsOn` / `finalizedBy` wiring becomes `[hooks]`, and a custom `Test` task over another source set becomes a test suite. Anything that relies on a `doLast { }` closure is listed for rewriting by hand. Spring Boot builds are covered too.

## Project status

jrs is **experimental**. It's single-module only and not a replacement for Maven or Gradle - it implements a deliberately narrow subset of what those tools do. Every milestone from the initial spec has landed, and the [roadmap](https://github.com/pwittchen/jrs/blob/master/ROADMAP.md) is now about hardening: I tried `jrs migrate` on my own Java and Kotlin projects and not everything worked, so the next step is a pinned corpus of real open-source projects (Spring Boot on Maven and Gradle, Ktor on the Kotlin DSL) that have to migrate, build, test, run and package with the same classpath and the same test results as their original builds.

## Installation

jrs needs JDK 17 or newer. On macOS or Linux:

```
curl -fsSL https://getjrs.dev/install.sh | sh
```

or from source, with a Rust toolchain:

```
cargo install --git https://github.com/pwittchen/jrs.git
```

## Links

- website and docs: [getjrs.dev](https://getjrs.dev)
- source code: [github.com/pwittchen/jrs](https://github.com/pwittchen/jrs)
- design: [INITIAL_SPEC.md](https://github.com/pwittchen/jrs/blob/master/specs/INITIAL_SPEC.md) and [ARCH.md](https://github.com/pwittchen/jrs/blob/master/ARCH.md)

Released under the Apache 2.0 license.
