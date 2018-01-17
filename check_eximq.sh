#!/bin/bash
# Nagios plugin for check exim4 mails in queue.
# URL: https://github.com/zevilz/NagiosEximStatus
# Author: Alexandr "zEvilz" Emshanov
# License: MIT
# Version: 1.0.0

usage()
{
	echo
	echo "Usage: bash $0 [options]"
	echo
	echo "Nagios plugin for check exim4 mails in queue."
	echo
	echo "Options:"
	echo
	echo "    -w <integer>,           Specify warning number of emails in queue."
	echo "    --warning=<integer>"
	echo
	echo "    -c <integer>,           Specify critical number of emails in queue."
	echo "    --critical=<integer>"
	echo
}
checkParams()
{
	if [ -z $Q_WARNING ]; then
		echo "ERROR! Warning number of mails not set."
		exit 2
	fi
	if ! [[ $Q_WARNING =~ ^-?[0-9]+$ ]]; then
		echo "ERROR! Warning number of mails must be integer."
		exit 2
	fi
	if [ -z $Q_CRITICAL ]; then
		echo "ERROR! Critical number of mails not set."
		exit 2
	fi
	if ! [[ $Q_CRITICAL =~ ^-?[0-9]+$ ]]; then
		echo "ERROR! Critical number of mails must be integer."
		exit 2
	fi
	if [ $Q_WARNING -ge $Q_CRITICAL ]; then
		echo "ERROR! Critical number of mails must be greater than warning number of mails."
		exit 2
	fi
}

Q_WARNING=""
Q_CRITICAL=""
PARAMS_NUM=$#

while [ 1 ] ; do
	if [ "${1#--warning=}" != "$1" ] ; then
		Q_WARNING="${1#--warning=}"
	elif [ "$1" = "-w" ] ; then
		shift ; Q_WARNING="$1"

	elif [ "${1#--critical=}" != "$1" ] ; then
		Q_CRITICAL="${1#--critical=}"
	elif [ "$1" = "-c" ] ; then
		shift ; Q_CRITICAL="$1"

	elif [ -z "$1" ] ; then
		break
	else
		echo "ERROR! Unknown key detected!"
		usage
		exit 2
	fi
	shift
done

if [[ $PARAMS_NUM -eq 0 ]]
then
	usage
	exit 3
fi

checkParams

Q_COUNT=$(exim -bpc)

if [ -z $Q_COUNT ]; then
	exit 3
fi

if [ $Q_COUNT -ge $Q_CRITICAL ]; then
	echo "Exim4 CRITICAL: $Q_COUNT mails in queue"
	exit 2
elif [ $Q_COUNT -ge $Q_WARNING ]; then
	echo "Exim4 WARNING: $Q_COUNT mails in queue"
	exit 1
elif [ $Q_COUNT -lt $Q_WARNING ]; then
	echo "Exim4 OK: $Q_COUNT mails in queue"
	exit 0
fi
