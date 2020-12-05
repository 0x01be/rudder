FROM 0x01be/xpra

RUN apk add --no-cache --virtual rudder-runtime-dependencies \
    git \
    make \
    bash \
    xfce4-terminal \
    mc \
    vim \
    tmux \
    docker-cli \
    coreutils \
    tar \
    gzip \
    wget \
    curl \
    expat \
    python3 \
    python3-tkinter \
    py3-yaml \
    py3-boto3 \
    py3-requests \
    py3-matplotlib \
    py3-jinja2 \
    py3-xlsxwriter \
    py3-pip \
    ruby-libs \
    tcsh \
    tcl-dev \
    tk-dev \
    m4 \
    glu \
    pcre \
    libgomp \
    libgnat \
    libxext \
    libffi \
    libxft \
    libsm \
    libjpeg \
    libxpm \
    libxt \
    gettext \
    qt5-qtbase-x11 \
    qt5-qtxmlpatterns \
    qt5-qtsvg \
    qt5-qttools \
    mesa-dri-swrast \
    gdb \
    g++ \
    libtool &&\
    apk add --no-cache --virtual rudder-edge-runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    geany \
    py3-pandas \
    ngspice &&\
    ln -s /usr/lib/libtcl8.6.so /usr/lib/libtcl.so &&\
    pip install -U pip pudb strsimpy

COPY --from=0x01be/gtkwave:xpra /opt/gtkwave/ /opt/gtkwave/
COPY --from=0x01be/netgen:xpra /opt/netgen/ /opt/netgen/
COPY --from=0x01be/qflow:xpra /opt/qflow/ /opt/qflow/
COPY --from=0x01be/klayout:xpra /opt/klayout/ /opt/klayout/
COPY --from=0x01be/openroad:xpra /opt/openroad/ /opt/openroad/
COPY --from=0x01be/xschem:xpra /opt/xschem/ /opt/xschem/
COPY --from=0x01be/opendp /opt/opendp/ /opt/opendp/
COPY --from=0x01be/ops /opt/ops/ /opt/ops/
COPY --from=0x01be/padring /opt/padring/ /opt/padring/
COPY --from=0x01be/replace /opt/replace/ /opt/replace/
COPY --from=0x01be/triton /opt/triton/ /opt/triton/
COPY --from=0x01be/yosys /opt/yosys/ /opt/yosys/
COPY --from=0x01be/iverilog /opt/iverilog/ /opt/iverilog/
COPY --from=0x01be/verilator /opt/verilator/ /opt/verilator/
COPY --from=0x01be/magic:xpra-threads /opt/magic/ /opt/magic/
COPY ./.local/ ${WORKSPACE}/.local/
COPY ./.config/ ${WORKSPACE}/.config/

ENV PDK_ROOT=/opt/pdk

ENV TARGET_DIR=${WORKSPACE}/caravel \
    OUT_DIR=${WORKSPACE}/caravel \
    DESIGN_NAME=caravel \
    SUB_DESIGN_NAME=mprj \
    SCRIPTS_ROOT=${WORKSPACE}/precheck \
    PDKPATH=${PDK_ROOT}/sky130A \
    MAGIC_MAGICRC=${PDK_ROOT}/sky130A/libs.tech/magic/sky130A.magicrc \
    MAGIC_TECH=${PDK_ROOT}/sky130A/libs.tech/magic/sky130A.tech \
    MAGTYPE=mag

RUN git clone --depth 1 --branch  main   https://github.com/efabless/open_mpw_precheck.git ${SCRIPTS_ROOT} &&\
    git clone --depth 1 --branch master  https://github.com/tcltk/tcllib.git /tmp/tcllib && cd /tmp/tcllib && ./configure --prefix=/usr && make && make install &&\
    mkdir -p ${TARGET_DIR} ${PDK_ROOT} &&\
    chown -R ${USER}:${USER} ${WORKSPACE} ${PDK_ROOT} &&\
    sed -i.bak 's/ash/bash/g' /etc/passwd &&\
    rm -rf /tmp/*

# Fix weird references
RUN mkdir -p /home/ag/pdks /home/xrex/usr/devel/pdks/test &&\
    ln -s ${PDK_ROOT}/sky130A /home/ag/pdks/sky130A &&\
    ln -s ${PDK_ROOT}/sky130A /home/xrex/usr/devel/pdks/sky130A &&\
    ln -s ${PDK_ROOT}/sky130A /home/xrex/usr/devel/pdks/test/sky130A

USER ${USER}
WORKDIR ${WORKSPACE}
ENV PATH=${PATH}:/opt/netgen/bin:/opt/qflow/bin:/opt/magic/bin:/opt/klayout/bin:/opt/openroad/bin:/opt/opendp/bin:/opt/ops/bin:/opt/padring/bin:/opt/replace/bin:/opt/triton/bin:/opt/yosys/bin:/opt/ghdl/bin:/opt/iverilog/bin:/opt/verilator/bin:/opt/gtkwave/bin:/opt/xschem/bin/:${WORKSPACE}/.local/bin/ \
    PYTHONPATH=/usr/lib/python3.8/site-packages/:/opt/klayout/lib/python3.8/site-packages/ \
    DOCKER_HOST=tcp://docker:2375 \
    COMMAND="xfce4-terminal"

