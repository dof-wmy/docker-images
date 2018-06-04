#!/bin/bash

SS_CONFIG=${SS_CONFIG:-""}
SS_MODULE=${SS_MODULE:-"ss-server"}
KCP_CONFIG=${KCP_CONFIG:-""}
KCP_MODULE=${KCP_MODULE:-"kcpserver"}
KCP_FLAG=${KCP_FLAG:-"false"}

SSCLIENT_PORT=${SSCLIENT_PORT:-""}
PRIVOXY_PORT=${PRIVOXY_PORT:-""}
PROXY_IP=${PROXY_IP:-""}

while getopts "s:m:k:e:x" OPT; do
    case $OPT in
        s)
            SS_CONFIG=$OPTARG;;
        m)
            SS_MODULE=$OPTARG;;
        k)
            KCP_CONFIG=$OPTARG;;
        e)
            KCP_MODULE=$OPTARG;;
        x)
            KCP_FLAG="true";;
    esac
done

if [ "$KCP_FLAG" == "true" ] && [ "$KCP_CONFIG" != "" ]; then
    echo -e "\033[32mStarting kcptun......\033[0m"
    $KCP_MODULE $KCP_CONFIG 2>&1 &
else
    echo -e "\033[33mKcptun not started......\033[0m"
fi

if [ "$SS_CONFIG" != "" ]; then
    echo -e "\033[32mStarting shadowsocks......\033[0m"
    if [ "$SSCLIENT_PORT" != "" ] && [ "$PRIVOXY_PORT" != "" ] && [ "$PROXY_IP" != "" ]; then
        echo -e "\033[32mStarting privoxy......\033[0m"
        echo "listen-address ${PROXY_IP}:${PRIVOXY_PORT}">>/etc/privoxy/config
        echo "forward-socks5t / 127.0.0.1:${SSCLIENT_PORT} .">>/etc/privoxy/config
        privoxy --no-daemon /etc/privoxy/config &
    fi
    $SS_MODULE $SS_CONFIG
else
    echo -e "\033[31mError: SS_CONFIG is blank!\033[0m"
    exit 1
fi
