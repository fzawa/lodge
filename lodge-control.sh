#!/bin/bash

#
# Settings
#

UNICORN_PID_FILE=tmp/unicorn.pid
SOLR_PID_FILE=solr/pids/production/sunspot-solr-production.pid

EXEC_USER=sup-admin
EXPECT_RUBY_VER=2.3.0

cd `dirname $0`


#
# Checks
#

ARG_ERR_MSG="usage: sudo -u $EXEC_USER -i (absolute path of this script) (start/restart/stop)"

if [ "`whoami`" != "$EXEC_USER" ]; then
	echo "only '$EXEC_USER' can exec this script"
	echo $ARG_ERR_MSG
	exit 1
fi

TERMINATE_ONLY=0
if [ $# -ne 1 ]; then
	echo $ARG_ERR_MSG
	exit 1
fi
case $1 in
	"start")
		;;
	"restart")
		;;
	"stop")
		TERMINATE_ONLY=1
		;;
	*)
		echo $ARG_ERR_MSG
		exit 1
esac


#
# Terminate
#

if [ -e $UNICORN_PID_FILE ]; then
	PID=`cat $UNICORN_PID_FILE`
	echo "Lodge is running (PID $PID). Waiting for termination."
	kill -TERM $PID
	if [ $? -eq 0 ]; then
		wait $PID 2>/dev/null
	else
		rm $UNICORN_PID_FILE
	fi
	echo ""
fi

if [ -e $SOLR_PID_FILE ]; then
	PID=`cat $SOLR_PID_FILE`
	echo "Solr is running (PID $PID). Waiting for termination."
	bin/rake sunspot:solr:stop RAILS_ENV=production
	if [ $? -ne 0 ]; then
		exit 1
	fi
	wait $PID 2>/dev/null
	rm $SOLR_PID_FILE
	echo ""
fi

if [ $TERMINATE_ONLY -eq 1 ]; then
	exit 0
fi


#
# Launch
#

# Ruby version check
#RUBY_VER=`rbenv version | sed "s/\([^ ]*\).*/\1/"`
#if [ "$RUBY_VER" -ne "$EXPECT_RUBY_VER" ]; then
#	echo "ERR: Ruby version mismatch (now: $RUBY_VER, expect: $EXPECT_RUBY_VER)"
#	exit 1
#fi

echo "Staring Solr..."
bin/rake sunspot:solr:start RAILS_ENV=production
if [ $? -ne 0 ]; then
	exit 1
fi
echo ""

echo "Staring Lodge..."
bundle exec unicorn_rails -D -c config/unicorn.rb -E production
if [ $? -ne 0 ]; then
	exit 1
fi
echo "Lodge is runnning!"

