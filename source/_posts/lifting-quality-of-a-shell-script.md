---
title: Lifting quality of a shell script
date: 2016-11-30 23:29:00
tags:
	- bash
	- testing
---

Introduction
------------

In release cycle of our team at work, we need to perform so-called system tests. In order to do that, we need to log into Artifactory, search for the latest release package, check if it's up to date, download it, unzip it, install internal configuration recipe, compile, initialize & run it. Not all of that can be easily automated, but I thought that at least searching & downloading phase can be done from the terminal in a semi-automated way. That's why I created [**ydownloader**](https://github.com/pwittchen/ydownloader) shell script.

Writing a script with unit tests and continuous integration
-----------------------------------------------------------

I'm not an expert in shell scripting, so I also wanted to learn more about it. In addition, I wanted to apply best software development practices in that script. Someone can say that in the case of a simple shell script proper engineering may be a superfluity, but in my opinion, the simplicity of the project is not an excuse for doing it the right way. Especially, if we want to use it in the future. That's why I divided this script into smaller functions, added command line arguments handling and help for the users. Moreover, I added [unit tests](https://github.com/pwittchen/ydownloader/blob/master/test.sh) with [shunit2](https://github.com/kward/shunit2) (yes, we can write unit tests for the shell scripts) and [continuous integration with Travis CI](https://travis-ci.org/pwittchen/ydownloader) server. In the "Clean Code" book, we can read that code without unit tests is not clean by definition. After dividing script into smaller functions, it was much easier to test it. My script is accepting command line arguments, so I needed to do the following trick to make it testable and include it in the testing script:

```bash
if \[ "$TEST_MODE" == "" \]
then
  TEST_MODE=false
fi

if \[ "$TEST_MODE" = false \] ; then
  # parse command line arguments here...
else
  echo "TEST_MODE enabled"
fi
```

Then, I could write unit tests:

```bash
TEST_MODE=true
. ./ydownloader # load script to be tested
echo "RUNNING UNIT TESTS..."

testCutLastChars() {
  # given
  valueToCut='testString'
  expectedValue='testStri'

  # when
  actualValue=$(echo $valueToCut | cutLastChars 3)

  # then
  assertEquals $expectedValue $actualValue
}

\# more tests goes here...
. ./shunit2/shunit2 # load shunit2
```

There are also other solutions for unit testing like [bats](https://github.com/sstephenson/bats), [assert.sh](https://github.com/lehmannro/assert.sh) and others. We can choose what we like. We can also use additional tools like [shunit2-colorize](https://github.com/joelpurra/shunit2-colorize) to make our console output of shunit2 tests look like a rainbow if we are not fans of monochromatic terminal. Moreover, we can use static code analysis tools for shell scripts like [shellcheck](https://github.com/koalaman/shellcheck). In addition, I prepared simple [install script](https://github.com/pwittchen/ydownloader/blob/master/install.sh), which allows to install script locally via `curl` or `wget`. Of course, project has sufficient documentation in `README.md` file.

Short recap
-----------

It was really nice coding exercise. Now, I feel much more comfortable with shell scripting, but there's still a lot to learn. I recommend trying applying a similar approach in your scripts if you haven't done it yet. If you want to browse complete project, check it out in my repository: [**https://github.com/pwittchen/ydownloader**](https://github.com/pwittchen/ydownloader).