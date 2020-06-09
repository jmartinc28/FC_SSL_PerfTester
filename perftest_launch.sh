#!/bin/bash
start=`date +%s`

#Change to the lowest port to use by iperf, each new container will increment port by 1
basePort=5201 
#VPN Server IP / Username / Password
fgtVPNIP=10.20.28.2:10443
fgtVPNUser=vpnuser
fgtVPNPass=VPNpassw0rd

#iperf Server IP
iperfSIP=10.20.28.228

lastPort=$(($basePort + $1 - 1))    

echo "Launching $1 threats, ports from $basePort to $lastPort"

for (( c=$basePort; c<=$lastPort; c++ ))
do
	#echo ""
	echo "Bringing up container #$(($c - $basePort)) on port $c"

	#iperf Server
	screen -S $c.iperfs -d -m iperf3 -s -p $c 

	#SSL VPN Container
	screen -S $c.ssl -d -m docker run -it --rm --privileged --net fortinet \
		-e VPNADDR=$fgtVPNIP -e VPNUSER=$fgtVPNUser -e VPNPASS=$fgtVPNPass \
		-e VPNTIMEOUT=15 --name "container.$c" fc_perf_tst:0.1 
	sleep 1

	#iperf Client on Container
	screen -S $c.iperfc -d -m docker exec -ti "container.$c" /bin/bash -c "echo 'Sleeping...' && sleep 20 && iperf3 -t 1200 -b 5m -c $iperfSIP -p ${c}"

	#mpstat
done

end=`date +%s`
runtime=$((end-start))
echo "Runtime $runtime seconds"