# Rudder

Learn, share and teach ASIC design using open tools and technologies:

 - [skywater-pdk](https://skywater-pdk.readthedocs.io/)
 - [open_pdks](http://www.opencircuitdesign.com/open_pdks/)
 - [caravel](https://github.com/efabless/caravel/)
 - [magic](http://opencircuitdesign.com/magic/)
 - [qflow](http://opencircuitdesign.com/qflow/)
 - [netgen](http://opencircuitdesign.com/netgen/)
 - [openroad](https://theopenroadproject.org/)
 - [klayout](https://www.klayout.de/)
 - [xschem](http://repo.hu/projects/xschem/)
 - [gtkwave](http://gtkwave.sourceforge.net/)
 - [yosys](http://www.clifford.at/yosys/)
 - [verilator](https://www.veripool.org/wiki/verilator)
 - [iverilog](http://iverilog.icarus.com/)
 - [padring](https://github.com/YosysHQ/padring)
 - [triton](https://github.com/The-OpenROAD-Project/TritonRoute)
 - [replace](https://github.com/The-OpenROAD-Project/RePlAce)
 - etc.

## Components

### Docker images

 - [0x01be/rudder](https://hub.docker.com/r/0x01be/rudder/)
 - [0x01be/openpdks](https://hub.docker.com/r/0x01be/openpdks/) 

## Usage

### Install or update

```
docker pull 0x01be/rudder
```

### Prepare or reset [PDK](https://skywater-pdk.readthedocs.io/)

```
docker pull 0x01be/openpdks:timedwards
docker volume rm pdk
docker volume create pdk
docker run --rm -ti -v pdk:/opt/pdk 0x01be/openpdks:timedwards sh -c "mv /opt/skywater-pdk/* /opt/pdk/ && ln -s /opt/pdk/sky130A/libs.tech/magic /opt/pdk/sky130A/libs.tech/magic/current && ln -s /opt/pdk/sky130A/libs.tech /opt/pdk/libs.tech"
```

### Prepare or reset [Harness](https://github.com/efabless/caravel/)

```
docker volume rm caravel
docker volume create caravel
docker run --rm -ti -v caravel:/opt/caravel alpine sh -c "apk add git make gzip && git clone --branch mpw-one-a --recursive https://github.com/efabless/caravel.git /opt/caravel && adduser -D -u 1000 xpra && chown -R xpra:xpra /opt/caravel && cd /opt/caravel && make uncompress"
```

### View in Magic

```
docker run --rm --name magic -ti -p 10000:10000 -v pdk:/opt/pdk -v caravel:/home/xpra/caravel -e COMMAND=m 0x01be/rudder
```

Magic should be available at http://localhost:10000/

![Magic screenshot](screenshots/magic.png)

### View in KLayout

```
docker run --rm --name klayout -ti -p 10001:10000 -v pdk:/opt/pdk -v caravel:/home/xpra/caravel -e COMMAND=k 0x01be/rudder
```

Klayout should be available at http://localhost:10001/

![KLayout screenshot](screenshots/klayout.png)

### Run DRC, consistency tests and the [eFabless precheck](https://github.com/efabless/open_mpw_precheck)

```
docker run --rm -ti -v pdk:/opt/pdk -v caravel:/home/xpra/caravel 0x01be/rudder bash -c "drc && consistency && check"
```

