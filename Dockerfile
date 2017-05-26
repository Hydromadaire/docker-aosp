FROM ubuntu:14.04

# Default Gitlab build dir
VOLUME "/builds/tophat"

# By default Ubuntu doesn't know where to get the packages
RUN sudo apt-get update

# Required packages for AOSP - https://source.android.com/source/initializing
RUN sudo apt-get install -y git-core gnupg flex bison gperf build-essential \
                            zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
                            lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
                            libgl1-mesa-dev libxml2-utils xsltproc unzip

# Use JDK 7 for Crono buiolds
RUN sudo apt-get install -y openjdk-7-jdk

# Install python for repo to work, and vim for debugging convenience
RUN sudo apt-get install -y python vim

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

ENV USE_CCACHE 1
ENV CCACHE_DIR /builds/tophat/ccache
