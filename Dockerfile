FROM ubuntu:14.04

# Default Gitlab build dir
VOLUME "/builds/sombrero"

# By default Ubuntu doesn't know where to get the packages
RUN sudo apt-get update

# Required packages for AOSP - https://source.android.com/source/initializing
RUN sudo apt-get install -y git-core gnupg flex bison gperf build-essential \
                            zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
                            lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
                            libgl1-mesa-dev libxml2-utils xsltproc unzip

# Install add-apt-repository
RUN sudo apt-get install -y software-properties-common

# Use JDK 7 for Crono
RUN sudo apt-get install -y openjdk-7-jdk

# Use JDK 8 for Oreo
RUN sudo apt-add-repository ppa:openjdk-r/ppa
RUN sudo apt-get update
RUN sudo apt-get install -y openjdk-8-jdk

# Install python for repo to work, and vim for debugging convenience
RUN sudo apt-get install -y python vim

# Install bc for MTK builds
RUN sudo apt-get install -y bc

# Install hexdump and imagemagick to support CM13
RUN sudo apt-get update
RUN sudo apt-get install -y bsdmainutils imagemagick

# Install ssh agent if it is not already installed
RUN which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )

# Install Repo - https://source.android.com/source/downloading
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
RUN chmod a+x /usr/local/bin/repo

# Configure git username so repo doesn't run interactive prompt
RUN git config --global user.name 'Android Build'
RUN git config --global user.email 'developers@chooseblocks.com'
RUN git config --global color.ui true

# Prevent ssh host prompts
RUN mkdir -p ~/.ssh
RUN echo "Host * \n\t StrictHostKeyChecking no \n\t UserKnownHostsFile /dev/null" > ~/.ssh/config

# Enable CCache https://source.android.com/source/initializing
RUN mkdir -p /builds/tophat/ccache

# Install android SDK for building apps
COPY android-sdk_r24.3.3-linux.tgz /root/sdk.tgz
RUN tar -xvzf /root/sdk.tgz
ENV ANDROID_HOME $PWD/android-sdk-linux
RUN (while true; do sleep 1; echo y; done) | $ANDROID_HOME/tools/android update sdk --no-ui --all --filter android-26,build-tools-26.0.1,extra-android-m2repository,platform-tools

ENV USE_CCACHE 1
ENV CCACHE_DIR /builds/tophat/ccache
