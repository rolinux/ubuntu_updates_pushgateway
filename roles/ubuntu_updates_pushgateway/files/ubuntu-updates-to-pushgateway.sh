#!/bin/bash

# comment enable echo/debug
echo() { :; }

PUSHGATEWAY="http://nuc6:30091"

INSTANCE=`uname -n`

echo $INSTANCE

# start with apt update -qq
apt update -qq

# parse updates total and security
read -r TOTAL SECURITY <<< $(/usr/lib/update-notifier/apt-check 2>&1 | tr ';' ' ')

echo $TOTAL
echo $SECURITY

# if zero updates then delete any existing gauge

if (( $TOTAL == 0 )); then
  echo "No upgrades"
  /usr/bin/curl -X DELETE $PUSHGATEWAY/metrics/job/ubuntu_updates/instance/$INSTANCE
  exit 0
fi

# if not zero set gauge
echo "We have $TOTAL total upgrades and $SECURITY security upgrades"

cat <<EOF | /usr/bin/curl --data-binary @- $PUSHGATEWAY/metrics/job/ubuntu_updates/instance/$INSTANCE
# TYPE ubuntu_updates_total gauge
ubuntu_updates_total{instance="$INSTANCE",job="ubuntu_updates"} $TOTAL
# TYPE ubuntu_updates_security gauge
ubuntu_updates_security{instance="$INSTANCE",job="ubuntu_updates"} $SECURITY
EOF
