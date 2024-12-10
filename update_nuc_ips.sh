#!/bin/bash

# GET macs from .env
source .env

# Find IPs
IP_A=$(ip neigh | awk -v mac="$ETHER_A" '$3 == mac {print $1}')
IP_B=$(ip neigh | awk -v mac="$ETHER_B" '$3 == mac {print $1}')

echo $(ip neigh)

exit 0

# If IPs are not found use the invasive method
if [ -z "$IP_A" ] || [ -z "$IP_A" ]; then
  echo "No IP found ... starting nmap"
  NMAP_RESULT=$(nmap -T5 -sn $IP_SUBNET_A $IP_SUBNET_B)
  echo $NMAP_RESULT

  IP_A=$(echo $NMAP_RESULT | awk -v mac="$ETHER_A" '$3 == mac {print $1}')
  IP_B=$(echo $NMAP_RESULT | awk -v mac="$ETHER_B" '$3 == mac {print $1}')
  echo "Found IPs:"
  echo $IP_A
  echo $IP_B
fi

DEVICES_A=$(sshpass -p "$MACHINE_PASSWORD" ssh $NAME_A@$IP_A "sudo uhd_find_devices")
echo $DEVICES_A

cat <<EOF >README.md
# NTIA lab info

UE1:
ssh ${NAME_A}@${IP_A}


UE2:
ssh ${NAME_B}@${IP_B}

EOF
