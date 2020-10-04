# I decided not to use https://github.com/ejuarezg/containers/ (suggested in Iosevka readme)
# It has a largish code iosevka code download step AND npm install in the run , I wanted to bake that into the image.
# Keep in minf that means you need to rebuild this image if:
# - Iosevka source is updated
# - The private toml is changed.

# Could probably change this image to 14-buster-slim if I apt-get python - the npm install needs it. 
FROM node:14-buster


# The first RUN is copy paste from https://github.com/ejuarezg/containers/blob/master/iosevka_font/Dockerfile
# I'm using an image that the node image so I deleted the install step for this.

ARG OTFCC_VER=0.10.4
ARG PREMAKE_VER=5.0.0-alpha15
ARG NODE_VER=14

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        build-essential \
        file \
        curl \
        ca-certificates \
        ttfautohint \
    && cd /tmp \
    && curl -sSLo premake5.tar.gz https://github.com/premake/premake-core/releases/download/v${PREMAKE_VER}/premake-${PREMAKE_VER}-linux.tar.gz \
    && tar xvf premake5.tar.gz \
    && mv premake5 /usr/local/bin/premake5 \
    && rm premake5.tar.gz \
    && curl -sSLo otfcc.tar.gz https://github.com/caryll/otfcc/archive/v${OTFCC_VER}.tar.gz \
    && tar xvf otfcc.tar.gz \
    && mv otfcc-${OTFCC_VER} otfcc \
    && cd /tmp/otfcc \
    && premake5 gmake \
    && cd build/gmake \
    && make config=release_x64 \
    && cd /tmp/otfcc/bin/release-x64 \
    && mv otfccbuild /usr/local/bin/otfccbuild \
    && mv otfccdump /usr/local/bin/otfccdump \
    && cd /tmp \
    && rm -rf otfcc/ otfcc.tar.gz \
    && rm -rf /var/lib/apt/lists/*

# Copy all the source (I've only commented out stuff instantly obviously not relevant to build)
#COPY ./.github /build/.github
#COPY ./changes /build/changes
COPY ./font-src /build/font-src
#COPY ./images /build/images
COPY ./params /build/params
COPY ./sample-text /build/sample-text
COPY ./snapshot-src /build/snapshot-src
COPY ./utility /build/utility
#COPY ./.dockerignore /build/.dockerignore
#COPY ./.editorconfig /build/.editorconfig
#COPY ./.eslintrc.json /build/.eslintrc.json
#COPY ./.gitattributes /build/.gitattributes
#COPY ./.gitignore /build/.gitignore
COPY ./.npmrc /build/.npmrc
#COPY ./.prettierrc.yaml /build/.prettierrc.yaml
#COPY ./BackersArchive.md /build/BackersArchive.md
COPY ./build-plans.toml /build/build-plans.toml
#COPY ./Dockerfile /build/Dockerfile
#COPY ./LICENSE.md /build/LICENSE.md
COPY ./package.json /build/package.json
#COPY ./private-build-plans.sample.toml /build/private-build-plans.sample.toml
# This must be copied later (layering) #COPY ./private-build-plans.toml /build/private-build-plans.toml
#COPY ./README.md /build/README.md
COPY ./verdafile.js /build/verdafile.js

# dist is the default build output folder, should bindmount it to get the output.
RUN mkdir -p /build/dist/

# This is an expensive step, hence keep the private build toml afterwards.
RUN cd /build/ && npm i

COPY ./private-build-plans.toml /build/private-build-plans.toml
# RUN cd /build/ npm build -- contents::mun

WORKDIR /build
ENTRYPOINT ["/bin/bash"]