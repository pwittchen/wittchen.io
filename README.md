wittchen.io
===========

this is source of [wittchen.io](http://wittchen.io), which is my personal website and blog based on [hugo](https://gohugo.io/)

writing
-------

to create a new note (post), type

```
hugo new content/notes/my-new-note.md
```

running
-------

```
hugo server -D
```

deployment
----------

just update content and run command:

```
hugo -D
```

then commit and push your changes

deployment will be triggered automatically with github actions

docker
------

build and run:

```
docker compose up -d
```

to rebuild container, use `--build` flag

by default, the base URL is `http://localhost:8080/`, for production, override it via build argument:

```
docker build -t wittchen-io --build-arg BASE_URL="https://wittchen.io/" .
docker run -p 80:80 wittchen-io
```

or in docker-compose.yml:

```yaml
build:
  context: .
  args:
    BASE_URL: https://wittchen.io/
```

to stop and remove everything:

```
docker compose down --rmi all -v
```
