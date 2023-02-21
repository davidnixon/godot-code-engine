#!/bin/sh

trap "trap_signal EXIT" 0
trap "trap_signal SIGHUP" SIGHUP
trap "trap_signal SIGINT" SIGINT
trap "trap_signal SIGQUIT" SIGQUIT
trap "trap_signal SIGABRT" SIGABRT

trap_signal () {
    echo "Exiting with signal" "$@"
    exit
}
$*
