FROM 0x01be/opendp as opendp
FROM 0x01be/ops as ops
FROM 0x01be/padring as padring
FROM 0x01be/replace as replace
FROM 0x01be/qrouter as qrouter
FROM 0x01be/triton as triton
FROM 0x01be/iverilog as iverilog
FROM 0x01be/verilator as verilator
FROM 0x01be/yosys as yosys
FROM 0x01be/gtkwave:xpra as gtkwave
FROM 0x01be/qflow:xpra as qflow
FROM 0x01be/netgen:xpra as netgen
FROM 0x01be/klayout:xpra as klayout
FROM 0x01be/openroad:xpra as openroad
FROM 0x01be/xschem:xpra as xschem
FROM 0x01be/magic:xpra-threads as magic

FROM 0x01be/xpra

COPY --from=opendp /opt/* /opt/
COPY --from=ops /opt/* /opt/
COPY --from=padring /opt/* /opt/
COPY --from=replace /opt/* /opt/
COPY --from=triton /opt/* /opt/triton/
COPY --from=iverilog /opt/* /opt/
COPY --from=verilator /opt/* /opt/
COPY --from=yosys /opt/* /opt/
COPY --from=gtkwave /opt/* /opt/
COPY --from=qflow /opt/* /opt/
COPY --from=qrouter /opt/* /opt/
COPY --from=netgen /opt/* /opt/
COPY --from=klayout /opt/* /opt/
COPY --from=openroad /opt/* /opt/
COPY --from=xschem /opt/* /opt/
COPY --from=magic /opt/* /opt/

ENV PDK_ROOT=/opt/pdk \
    OPENLANE_ROOT=/opt/openlane
ENV TARGET_DIR=${WORKSPACE}/caravel \
    OUT_DIR=${WORKSPACE}/caravel \
    DESIGN_NAME=caravel \
    SUB_DESIGN_NAME=mprj \
    SCRIPTS_ROOT=${WORKSPACE}/checks \
    PDKPATH=${PDK_ROOT}/sky130A \
    MAGIC_MAGICRC=${PDK_ROOT}/sky130A/libs.tech/magic/sky130A.magicrc \
    MAGIC_TECH=${PDK_ROOT}/sky130A/libs.tech/magic/sky130A.tech \
    MAGTYPE=mag

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
    ncurses \
    tcsh \
    tcl-dev \
    tk-dev \
    m4 \
    glu \
    gmp \
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
    qt5-qtbase \
    qt5-qtbase-x11 \
    qt5-qtdeclarative \
    qt5-qtxmlpatterns \
    qt5-qtmultimedia \
    qt5-qtsvg \
    qt5-qttools \
    qt5-qtwayland \
    mesa-dri-swrast \
    spdlog \
    gdb \
    g++ \
    libtool &&\
    apk add --no-cache --virtual rudder-edge-runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    geany \
    py3-pandas \
    ngspice \
    glpk &&\
    ln -s /usr/lib/libtcl8.6.so /usr/lib/libtcl.so &&\
    pip install -U pip pudb strsimpy &&\
    git clone --depth 1 --branch main https://github.com/efabless/open_mpw_precheck.git ${SCRIPTS_ROOT} && rm -rf /usr/local/bin && ln -s ${SCRIPTS_ROOT} /usr/local/bin &&\
    git clone --depth 1 --branch mpw-one-a https://github.com/efabless/openlane.git ${OPENLANE_ROOT} && ln -s ${OPENLANE_ROOT} ${WORKSPACE}/openlane &&\
    git clone --depth 1 --branch master https://github.com/tcltk/tcllib.git /tmp/tcllib && cd /tmp/tcllib && ./configure --prefix=/usr && make install && rm -rf /tmp/* &&\
    mkdir -p ${TARGET_DIR} ${PDK_ROOT} &&\
    chown -R ${USER}:${USER} ${WORKSPACE} ${PDK_ROOT} &&\
    sed -i.bak 's/ash/bash/g' /etc/passwd

COPY ./.* ${WORKSPACE}/

USER ${USER}
WORKDIR ${WORKSPACE}
ENV PATH=${PATH}:/opt/netgen/bin:/opt/qflow/bin:/opt/magic/bin:/opt/klayout/bin:/opt/openroad/bin:/opt/opendp/bin:/opt/ops/bin:/opt/padring/bin:/opt/replace/bin:/opt/triton/bin:/opt/yosys/bin:/opt/ghdl/bin:/opt/iverilog/bin:/opt/verilator/bin:/opt/gtkwave/bin:/opt/xschem/bin/:${WORKSPACE}/.local/bin/ \
    PYTHONPATH=/usr/lib/python3.8/site-packages/:/opt/klayout/lib/python3.8/site-packages/ \
    DOCKER_HOST=tcp://docker:2375 \
    COMMAND="xfce4-terminal"

