#!/bin/bash

SPIDER_COMMAND=${SPIDER_COMMAND:-"crawl"}
SPIDER_OPTIONS=${SPIDER_OPTIONS:-""}
SPIDER_ARGS=${SPIDER_ARGS:-""}

if [ "$SPIDER_ARGS" != "" ]; then
    echo -e "\033[32mStarting spider......\033[0m"
    echo -e "\033[32m$SPIDER_COMMAND $SPIDER_OPTIONS $SPIDER_ARGS\033[0m"
    /usr/local/bin/scrapy $SPIDER_COMMAND $SPIDER_OPTIONS $SPIDER_ARGS
else
    echo -e "\033[31mError: SPIDER_ARGS is blank!\033[0m"
    exit 1
fi