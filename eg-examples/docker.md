# Docker

Run/test a dockerfile located in the current dir
`docker build -t <a tag: this is a human-readable name for the image> -f <dockerfile name> .`

If you COPY a file in the dockerfile that is in a sibling dir or a parent dir of the dir the docker file is in, then you should run the docker build command from the highest root dir that you need.
Ex if your dockerfile is located in ./proj/docker/x.Dockerfile
`docker build -t <tag-name> -f proj/docker/x.Dockerfile .`
