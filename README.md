# FC SSL PerfTester

Connect to a FortiNet VPNs through docker

## Usage

The container uses the forticlientsslvpn_cli linux binary to manage ppp interface

All of the container traffic is routed through the VPN, so you can in turn route host traffic through the container to access remote subnets.

IPerf is installed on the container so you can generate traffic, the Launch scrip will execute IPerf client on the Container and IPerf Server on the Host.

### Modify
You can change iperf commands on start.sh file, you will need to rebuild the container.

### Execute

```bash
# Build Container
docker build --tag fc_perf_tst:0.1 .

# Run Docker Manually
docker run -it --rm   --privileged   --net fortinet  -e VPNADDR=10.20.28.2:10443   -e VPNUSER=vpnuser   -e VPNPASS=VPNpassw0rd   -e VPNTIMEOUT=15 -e IPERFPORT=5201 fc_perf_tst:0.1

# Launch 150 SSL VPN Connections with the Script
./perftest_launch.sh 150

# Kill all Sessions
./perftest_killscreens.sh


```



### Precompiled binaries
Thanks to [https://hadler.me](https://hadler.me/linux/forticlient-sslvpn-deb-packages/) for hosting up to date precompiled binaries which are used in this Dockerfile.

### Personal Commands