#!/bin/csh

set node0 = 0x1100001
set node1 = 0x2100001
set page = 0

#set port = 2 #ge-0/0/8
if ($#argv >= 1) then
	if ($1 > 3) then
		echo "Incorrect port!"
		exit 1
	endif
	@ port = $1
else
	echo "Usage: $0 <port> [reg] [node] [val]"
	exit 0
endif
echo "port: $port"


if ($#argv >= 2) then
	set reg = $2
	set reg_node0 = `cprod -A $node0 -c show jbcm sfp_phy $port $page $reg |grep value |awk '{print $NF}'`
	set reg_node1 = `cprod -A $node1 -c show jbcm sfp_phy $port $page $reg |grep value |awk '{print $NF}'`
	if ("$reg_node0" == "$reg_node1") then
		echo "${reg}: $reg_node0"
	else
		echo "${reg}: $reg_node0, node1 $reg_node1"
	endif

	if ($#argv >= 4) then
		if ($3 == 0) then			
			set node = $node0
		else
			set node = $node1
		else
			echo "Incorrect node $3"
			echo "Usage: $0 <port> [reg] [node] [val]"
			exit 1
		endif

		set val = $4
		echo "Write node $node to $val"
		cprod -A $node -c set jbcm sfp_phy $port $page $reg $val |grep value
	endif

	exit 0
endif

set reg = 0
while($reg < 32)
	set reg_node0 = `cprod -A $node0 -c show jbcm sfp_phy $port $page $reg |grep value |awk '{print $NF}'`
	set reg_node1 = `cprod -A $node1 -c show jbcm sfp_phy $port $page $reg |grep value |awk '{print $NF}'`
	if ("$reg_node0" == "$reg_node1") then
		echo "${reg}: $reg_node0"
	else
		echo "${reg}: $reg_node0, node1 $reg_node1"
	endif
	@ reg = $reg + 1
end
