# Docker Bolt Image

## With Docker Compose

```
docker-compose up
```

## Bare Docker

```
git clone https://github.com/yappabe/docker-bolt.git bolt
cd bolt
docker build -t="bolt" .
docker run --name="bolttest" -p 80 -d bolt
```

Get the port docker is using for http/80:

```
 docker port bolttest 80
```
 

# Requirements

* Docker
* Docker Compose
* VirtualBox/boot2docker (on Mac OS X)
