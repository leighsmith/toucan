# -*- mode: sh -*-
# vi: set ft=bash :

FROM ubuntu:latest AS builder

WORKDIR /home/ubuntu

RUN apt-get update && apt-get install -y build-essential \
			      cmake \
			      g++ \
			      git \
			      minizip \
			      xorg-dev \
			      libglu1-mesa-dev \
			      mesa-common-dev \
			      mesa-utils \
			      ffmpeg \
			      openexr \
			      curl \
			      pipx \
			      libjpeg-dev \
			      libtiff-dev \
			      libpng++-dev \
			      libimath-dev

#			      python3-venv \
#			      python3-pip

ENV PATH=/home/ubuntu/toucan_python/bin:$PATH

RUN pipx ensurepath
RUN pipx install conan
# RUN conan profile detect

# RUN python3 -m venv /home/ubuntu/toucan_python
# RUN /home/ubuntu/toucan_python/bin/pip install conan

# Compile and install feather-tk library
RUN mkdir feather-tk
RUN cd feather-tk; git clone https://github.com/grizzlypeak3d/feather-tk.git
RUN cd feather-tk; sh feather-tk/sbuild-linux.sh feather-tk
# TODO replace with cmake --target install 
RUN tar -C feather-tk/install-Release -c -f - . | tar -C /usr/local -x -f -

# Unneeded because installed.
# RUN mkdir -p imath/imath_build
# RUN cd imath; git clone https://github.com/AcademySoftwareFoundation/Imath.git
# RUN cd imath/imath_build; cmake ../Imath --install-prefix /usr/local
# RUN cd imath; cmake --build imath_build --target install --config Release


RUN mkdir openFX
RUN cd openFX; git clone https://github.com/AcademySoftwareFoundation/openfx.git
# RUN cd openFX/openfx; scripts/build-cmake.sh

# Unable to get it because of github blocking automation.
# curl -O https://github.com/AcademySoftwareFoundation/openfx/releases/download/OFX_Release_1.5.1/openfx-linux-ubuntu-1.5.1.tar.gz
# https://github.com/AcademySoftwareFoundation/Imath/releases/download/v3.2.2/Imath-3.2.2.tar.gz

# RUN git clone https://github.com/AcademySoftwareFoundation/OpenImageIO.git
# RUN git clone https://github.com/AcademySoftwareFoundation/OpenColorIO.git
# RUN git clone https://github.com/AcademySoftwareFoundation/OpenTimelineIO.git

COPY . /home/ubuntu/toucan

# RUN sh toucan/sbuild-linux.sh
