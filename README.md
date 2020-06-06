Docs are at ./docs/index.html or ./docs/README.md

Requirements:

Docker

Build:

```docker build -t gram-sdk .```

Start:

```docker run -it --entrypoint /bin/bash  -v /var/run/docker.sock:/var/run/docker.sock -p 8088:8088 -p 8090:8090 -p 8084:8084 -p 8082:8082 -p 8083:8083 gram-sdk```

In container:
```gram deploy```