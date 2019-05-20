## Dockerized Git installation

Use this repo to build git from source inside a docker container.

Use the following commands
```bash
docker build -t c_builder_git .
```
And
```bash
docker run --rm -v $PWD/build:/home/appuser/build/ --name c_builder_container c_builder_git
```
