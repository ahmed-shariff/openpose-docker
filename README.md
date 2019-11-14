# openpose-docker
A docker build file for CMU openpose with Python API support

https://hub.docker.com/r/cwaffles/openpose

### Requirements
- Nvidia Docker runtime: https://github.com/NVIDIA/nvidia-docker#quickstart
- CUDA 10.0 or higher on your host, check with `nvidia-smi`

### Example
`docker run -it --rm --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 cwaffles/openpose`

The Openpose repo is in `/openpose`

Build the container using `docker run -it --rm <name>/openpose`
Finally to copy the compiled python library, run `docker run --name container <name>/openpose; docker cp container:/openpose/build/python/openpose .`
