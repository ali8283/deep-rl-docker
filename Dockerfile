FROM tensorflow/tensorflow:1.8.0-py3
MAINTAINER Eric Heiden <heiden@usc.edu>

ARG USER
ARG HOME

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 USER=$USER HOME=$HOME

RUN echo "The working directory is: $HOME"
RUN echo "The user is: $USER"

RUN mkdir -p $HOME
WORKDIR $HOME

RUN apt-get update && apt-get install -y \
        sudo \
        git \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    snapd \
    build-essential \
    apt-utils \
    curl \
    nano \
    vim \
    libfreetype6-dev \
    libpng12-dev \
    libzmq3-dev \
    git \
    python-numpy \
    python-dev \
    python-opengl \
    cmake \
    zlib1g-dev \
    libjpeg-dev \
    xvfb \
    libav-tools \
    xorg-dev \
    libboost-all-dev \
    libsdl2-dev \
    swig \
    libgtk2.0-dev \
    wget \
    ca-certificates \
    unzip \
    aptitude \
    pkg-config \
    qtbase5-dev \
    libqt5opengl5-dev \
    libassimp-dev \
    libpython3.5-dev \
    libboost-python-dev \
    libtinyxml-dev \
    golang \
    python-opencv \
    terminator \
    tmux \
    libcanberra-gtk-module \
    libfuse2 \
    libnss3 \
    fuse \
    python3-tk \
    libglfw3-dev \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libosmesa6-dev \
    net-tools \
    xpra \
    xserver-xorg-dev \
    libffi-dev \
    libxslt1.1 \
    libglew-dev \
    parallel \
    htop \
    apt-transport-https

# install Sublime Text
RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - \
    && echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y sublime-text

# install pycharm
#RUN wget https://download.jetbrains.com/python/pycharm-community-2018.2.4.tar.gz
#RUN snap install pycharm-community --classic
RUN add-apt-repository ppa:mystic-mirage/pycharm
RUN apt-get update
RUN apt-get install -y pycharm-community

RUN pip3 install --upgrade pip

RUN pip3 --no-cache-dir install \
    gym[]==0.10.3 \
    gym[Box2d] \
    pybullet \
    scikit-image \
    plotly \
    matplotlib \
    numpy \
    scipy \
    sklearn \
    pandas \
    Pillow \
    empy \
    tqdm \
    pyopengl \
    ipdb \
    cloudpickle \
    imageio \
    mpi4py \
    jsonpickle \
    gtimer \
    path.py \
    cached-property \
    flask \
    joblib \
    lasagne \
    PyOpenGL \
    six \
    pyprind \
    virtualenv


# Set up permissions to use same UID and GID as host system user
# https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu


# Install Baselines
RUN cd /opt && git clone https://github.com/openai/baselines.git && cd baselines && pip install -e .


ENV DOCKER_HOME=$HOME

COPY ./internal/ /

# Install VirtualGL
RUN dpkg -i /virtualgl_2.5.2_amd64.deb && rm /virtualgl_2.5.2_amd64.deb


ENV TERM xterm-256color


# 

EXPOSE 6006


ENTRYPOINT ["/docker-entrypoint.sh"]
