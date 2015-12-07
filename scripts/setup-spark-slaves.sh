#!/bin/bash
# http://stackoverflow.com/questions/6348902/how-can-i-add-numbers-in-a-bash-script

# ==> slaves2-node: modifying spark slaves
# ==> slaves2-node: adding node3
# ==> slaves2-node: adding node4

source "/vagrant/scripts/common.sh"
START=3
TOTAL_NODES=2

declare -A VMS_MAP=([1]="master" [2]="yarn" [3]="slaves1" [4]="slaves2")

while getopts s:t: option
do
	case "${option}"
	in
		s) START=${OPTARG};;
		t) TOTAL_NODES=${OPTARG};;
	esac
done

function setupSlaves {
	echo "modifying spark/slaves"
	for i in $(seq $START $TOTAL_NODES)
	do 
		nodeName="${VMS_MAP[$i]}-node"
		entry="${nodeName}"
		echo "adding ${entry}"
		echo "${entry}" >> $SPARK_CONF_DIR/slaves
	done
}

echo "setup hadoop slaves"
setupSlaves
