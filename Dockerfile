# https://hub.docker.com/r/cwaffles/openpose
FROM nvidia/cuda:10.0-cudnn7-devel

#get deps
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
python3.7-dev python3-pip git g++ wget make libprotobuf-dev protobuf-compiler libopencv-dev \
libgoogle-glog-dev libboost-all-dev libcaffe-cuda-dev libhdf5-dev libatlas-base-dev

#for python api
RUN pip3 install numpy opencv-python 
RUN python3 --version && python3 -c "import numpy; print(numpy.__version__)"
#replace cmake as old version has CUDA variable bugs
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.2/cmake-3.14.2-Linux-x86_64.tar.gz && \
tar xzf cmake-3.14.2-Linux-x86_64.tar.gz -C /opt && \
rm cmake-3.14.2-Linux-x86_64.tar.gz
ENV PATH="/opt/cmake-3.14.2-Linux-x86_64/bin:${PATH}"

#get openpose
WORKDIR /openpose
RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git .
RUN git submodule update --init 3rdparty/caffe
WORKDIR /openpose/3rdparty/caffe
RUN git checkout b6712ce
COPY 0001-Fix-for-some-stuff.patch .
RUN cat 0001-Fix-for-some-stuff.patch
RUN git config user.name "a" && git config user.email "a@b.c"
#build it
WORKDIR /openpose/build
RUN rm -rf * && cmake -D DOWNLOAD_BODY_MPI_MODEL=True -D BUILD_PYTHON=True -D GPU_MODE=CPU_ONLY -D DOWNLOAD_BODY_COCO_MODEL=True ..
WORKDIR /openpose/3rdparty/caffe
RUN git am 0001-Fix-for-some-stuff.patch
WORKDIR /openpose/build
RUN make -j8
WORKDIR /openpose
