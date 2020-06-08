# FC SSL PerfTester

This tool was developed to generate multiple SSL VPN Connections to a FortiGate and pass iperf traffic to do performance testing on the Fortigate.

This project is based on HybirdCorp (https://github.com/HybirdCorp/docker-forticlient) Docker Container that creates a Linux container with FortiClient and peforms 1 SSL VPN connection.

## Installation

To run the script you will need a Linux VM with the following dependences
* Docker
* bash
* iperf
* 2 Network Interfaces

A common implementation will look like this
![Basic Design](images/Design01.png)

## How it works
The container uses the forticlientsslvpn_cli linux binary to manage ppp interface, all of the container traffic is routed through the VPN.

IPerf is installed on the container so you can generate traffic, the Launch scrip will execute IPerf client on the Container and IPerf Server on the Host.

## Automation Scripts
perftest_launch.sh will launch one or multiple instances for the docker container and the iperf server on different ports, screen is used to background the commands, you can check launched process with screen, example
```bash
#Query opened Screens
screen -ls

#Attach to a Screen session
screen -r ID

#Detach from Screen session
CTRL+A CTRL+D

```
### Modify
You can change iperf commands on start.sh file, you will need to rebuild the container.

### Execute
```bash
# Build Container
docker build --tag fc_perf_tst:0.1 .

# Run Docker Manually
docker run -it --rm   --privileged   --net fortinet  -e VPNADDR=10.20.28.2:10443   -e VPNUSER=vpnuser   -e VPNPASS=VPNpassw0rd   -e VPNTIMEOUT=15 -e IPERFPORT=5201 fc_perf_tst:0.1

# Run multiple containers with the Script
./perftest_launch.sh 150

# Kill all Sessions
./perftest_killscreens.sh


```

### Precompiled binaries
Thanks to [https://hadler.me](https://hadler.me/linux/forticlient-sslvpn-deb-packages/) for hosting up to date precompiled binaries which are used in this Dockerfile.