#!/bin/bash
start=`date +%s`
basePort=5201
lastPort=$(($basePort + $1 - 1))    

echo "Launching $1 threats, ports from $basePort to $lastPort"

for (( c=$basePort; c<=$lastPort; c++ ))
do
	#echo ""
	echo "Bringing up container #$(($c - $basePort)) on port $c"
	screen -S $c.iperf -d -m iperf3 -s -p $c 
	screen -S $c.ssl -d -m docker run -it --rm   --privileged   --net fortinet  -e VPNADDR=10.20.28.2:10443   -e VPNUSER=vpnuser   -e VPNPASS=VPNpassw0rd   -e VPNTIMEOUT=15 -e IPERFPORT=$c fc_perf_tst:0.1
	sleep 1
	#mpstat
done

end=`date +%s`
runtime=$((end-start))
echo "Runtime $runtime seconds"