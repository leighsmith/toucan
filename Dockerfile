# -*- mode: sh -*-
# vi: set ft=bash :

FROM ubuntu:latest AS builder

WORKDIR /home/ubuntu

RUN apt-get update && apt-get install -y build-essential \
			      cmake \
			      g++ \
			      git \
			      minizip \
			      libminizip-dev \
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

# TODO:

# missing #include <ftk/Core/ObservableValue.h> replace with #include <ftk/Core/Observable.h>
# Missing OpenFX/ofxProperty.h need to install OpenFX headers properly.

# Clone, compile and install feather-tk library
RUN mkdir feather-tk
RUN cd feather-tk; git clone https://github.com/grizzlypeak3d/feather-tk.git
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
# TODO need to fully install this?

# RUN git clone https://github.com/OpenTimelineIO/toucan.git
# RUN git clone https://github.com/leighsmith/toucan.git
COPY . /home/ubuntu/toucan

# RUN sh toucan/sbuild-linux.sh


#			      python3-venv \
#			      python3-pip
# RUN python3 -m venv /home/ubuntu/toucan_python
# RUN /home/ubuntu/toucan_python/bin/pip install conan
