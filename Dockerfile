# -*- mode: sh -*-
# vi: set ft=bash :

FROM ubuntu:latest AS builder

WORKDIR /home/ubuntu

RUN apt-get update && apt-get install -y build-essential \
			      cmake \
			      g++ \
			      git \
			      minizip \
			      libminizip-ng-dev \
			      xorg-dev \
			      libglu1-mesa-dev \
			      mesa-common-dev \
			      mesa-utils \
			      curl \
			      pipx \
			      libjpeg-dev \
			      libtiff-dev \
			      libpng++-dev \
			      libimath-dev \
			      libopencv-dev \
			      ffmpeg \
			      libyaml-cpp-dev \
			      libavcodec-dev \
			      libavformat-dev \
			      libswscale-dev \
			      openimageio-tools \
			      libopenexr-dev \
			      libopenimageio-dev \
			      libopencolorio-dev \
			      libopentimelineio-dev

# Clone, compile and install feather-tk library
RUN mkdir feather-tk
RUN cd feather-tk; git clone https://github.com/grizzlypeak3d/feather-tk.git
# We revert feather-tk to the last date matching version to the current toucan main branch date.
# This is only needed until the toucan codebase and feather-tk library are synchronised in their APIs.
RUN cd feather-tk; git checkout 3cee68ec
RUN cd feather-tk; sh feather-tk/sbuild-linux.sh feather-tk
# TODO replace with cmake --target install 
RUN tar -C feather-tk/install-Release -c -f - . | tar -C /usr/local -x -f -

# Add the pipx installation location:
ENV PATH=/root/.local/share/pipx/venvs/conan/bin:$PATH

# We need conan for openFX building.
RUN pipx ensurepath
RUN pipx install conan
RUN conan profile detect

# TODO Unable to get it because of github blocking automation.
# curl -O https://github.com/AcademySoftwareFoundation/openfx/releases/download/OFX_Release_1.5.1/openfx-linux-ubuntu-1.5.1.tar.gz
RUN git clone https://github.com/AcademySoftwareFoundation/openfx.git
# TODO this doesn't build on arm64 Linux currently, can't find the architecture.
RUN cd openfx; scripts/build-cmake.sh
# TODO need to find a better installation method, cmake --target install
RUN mkdir /usr/local/include/OpenFX
RUN tar -C openfx/include -c -f - . | tar -C /usr/local/include/OpenFX -x -f -

# RUN git clone https://github.com/OpenTimelineIO/toucan.git
# RUN git clone https://github.com/leighsmith/toucan.git
COPY . /home/ubuntu/toucan

# RUN sh toucan/sbuild-linux.sh
