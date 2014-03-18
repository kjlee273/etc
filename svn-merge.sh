#!/bin/bash

if [ $# -lt 2 ]; then
	echo "usage: $0 [rev] [module0 module1 ...]"
	exit 1;
fi

REV=$1
MODULES=${@:2}
REPO_ROOT=`LANG=C; svn info $2 | grep "Repository Root" | sed 's/Repository Root: //'`
LOG_MESSAGE_FILE=log_message.tmp

echo $LANG

if [ ! -f $LOG_MESSAGE_FILE ];then
	echo "Merged from trunk" > $LOG_MESSAGE_FILE
fi

svn log --incremental -r$REV $REPO_ROOT | sed '/^$/d' | tee -a $LOG_MESSAGE_FILE

for MODULE in $MODULES;do
	echo
	echo $MODULE
	svn merge -c$REV $REPO_ROOT/$MODULE/trunk $MODULE
done
