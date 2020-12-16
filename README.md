# Rudder

Learn, share and collaborate on ASIC design using open tools and technologies:

 - [skywater-pdk](https://skywater-pdk.readthedocs.io/)
 - [open_pdks](http://www.opencircuitdesign.com/open_pdks/)
 - [caravel](https://github.com/efabless/caravel/)
 - [magic](http://opencircuitdesign.com/magic/)
 - [qflow](http://opencircuitdesign.com/qflow/)
 - [netgen](http://opencircuitdesign.com/netgen/)
 - [openlane](https://github.com/efabless/openlane/)
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

 - [0x01be/sdp](https://hub.docker.com/r/0x01be/sdp/)
 - [0x01be/rudder](https://hub.docker.com/r/0x01be/rudder/)
 - [0x01be/openpdks](https://hub.docker.com/r/0x01be/openpdks/) 


### Git repositories

 - [efabless/caravel](https://github.com/efabless/caravel)

## Usage

### Install or update

```
docker pull 0x01be/sdp
docker pull 0x01be/rudder
docker pull 0x01be/openpdks:1.0.85
```

### Expose the docker [API](https://docs.docker.com/engine/api/v1.41/) on port 2375

```
docker run --rm -d --name docker -p 127.0.0.1:2375:2375 -v /var/run/docker.sock:/var/run/docker.sock 0x01be/sdp
```

### Setup [PDK](https://skywater-pdk.readthedocs.io/) and [Harness](https://github.com/efabless/caravel/)

```
docker run --rm -ti --link docker 0x01be/rudder setup
```

### Make project

```
docker run --rm -ti -v pdk:/opt/pdk -v caravel:/home/xpra/caravel 0x01be/rudder make
```

### DRC

```
docker run --rm -ti -v pdk:/opt/pdk -v caravel:/home/xpra/caravel 0x01be/rudder drc
```

### Consistency check

```
docker run --rm -ti -v pdk:/opt/pdk -v caravel:/home/xpra/caravel 0x01be/rudder consistency
```

### [eFabless precheck](https://github.com/efabless/open_mpw_precheck)

```
docker run --rm -ti -v pdk:/opt/pdk -v caravel:/home/xpra/caravel 0x01be/rudder check
```

### Bash

```
docker run --rm -ti --link docker -v pdk:/opt/pdk -v caravel:/home/xpra/caravel 0x01be/rudder bash
```

Or in your browser:

```
docker run --rm -d --name rudder --link docker -p 127.0.0.1:10000:10000 -v pdk:/opt/pdk -v caravel:/home/xpra/caravel 0x01be/rudder
```

Bash should be available at http://localhost:10000/

![Bash screenshot](screenshots/bash.png)

### View in Magic

```
docker run --rm -d --name magic -p 127.0.0.1:10001:10000 -v pdk:/opt/pdk -v caravel:/home/xpra/caravel -e COMMAND=m 0x01be/rudder
```

Magic should be available at http://localhost:10001/

![Magic screenshot](screenshots/magic.png)

### View in KLayout

```
docker run --rm -d --name klayout -p 127.0.0.1:10002:10000 -v pdk:/opt/pdk -v caravel:/home/xpra/caravel -e COMMAND=k 0x01be/rudder
```

Klayout should be available at http://localhost:10002/

![KLayout screenshot](screenshots/klayout.png)

