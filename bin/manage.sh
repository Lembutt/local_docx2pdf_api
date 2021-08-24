#!/usr/bin/env bash

APPNAME='docx2pdf_api.service'
SERVICE="/lib/systemd/system/$APPNAME"
VENV='/home/tom/l/converter/env/bin/python3.9'
APP='/home/tom/l/converter/src/app.py'

CMD=$1
CMD2=$2

help_message () {
	echo '================================= CONSTANTS ======================================='
	echo "Name of service     - $APPNAME"
	echo "Path to service     - $SERVICE"
	echo "Path to environment - $VENV"
	echo "Path to app         - $APP"
	echo '============================ Available commands ==================================='
	echo "setup    - to setup service ('setup anyway' if wanted to rewrite service in systemd, auto-start)"
	echo 'start    - to start service'
	echo 'restart  - to restart service'
	echo 'stop     - to stop service'
	echo 'help     - to show this text'
	echo 'enable   - to enable automatically start on boot (default)'
	echo 'disable  - to disable automatically start on boot'
	echo 'status   - to show status of service'
	echo 'remove   - to remove service'

	echo 'delcache - to remove Python cache files'

	echo "================================== SYNTAX'S ========================================"
	echo 'sudo bash manages.sh [command]'
	echo 'sudo htop (for task manager)'
}


remove_service () {
	systemctl stop $APPNAME
        systemctl disable $APPNAME
        rm /etc/systemd/system/$APPNAME
        rm /etc/systemd/system/$APPNAME # and symlinks that might be related
        rm /usr/lib/systemd/system/$APPNAME
        rm /usr/lib/systemd/system/$APPNAME # and symlinks that might be related
        rm $SERVICE
        rm $SERVICE
        systemctl daemon-reload
        systemctl reset-failed
}

write_service_options () {
	echo '[Unit]'                     	      >> $SERVICE
	echo 'Description=docx2pdf service'           >> $SERVICE
	echo 'After=multi-user.target'                >> $SERVICE
	echo 'Conflicts=getty@tty1.service'           >> $SERVICE
	echo '                            '           >> $SERVICE
	echo '[Service]'                              >> $SERVICE
	echo 'Type=simple'                            >> $SERVICE
	echo "ExecStart=$VENV $APP"                   >> $SERVICE
	echo 'Restart=always'                         >> $SERVICE
	echo 'StandardInput=tty-force'                >> $SERVICE
	echo '                             '          >> $SERVICE
	echo '[Install]'                              >> $SERVICE
	echo 'WantedBy=multi-user.target'             >> $SERVICE
}

make_service () {
	if test -f $SERVICE
	then
		echo "Rewriting {$APPNAME}..."
		remove_service
	fi

	touch $SERVICE
	write_service_options
}

setup () {
	make_service
	echo 'Applying changes...'
	systemctl daemon-reload
	systemctl enable $APPNAME
	systemctl start  $APPNAME
	systemctl status $APPNAME
}

if [ -e $SERVICE ] || [ $CMD == 'setup' ]
then
	if [ $CMD == 'setup' ]
	then
	
		if [ -e $SERVICE ]  && [ $CMD2 == 'anyway' ]
		then
			setup
		elif [ -e $SERVICE ] && [[ $CMD2 != 'anyway' ]]
		then
			echo "Service $APPNAME already exists. To rewrite it, type 'sudo bash managebot.sh setup anyway'"
		else
			setup
		fi

	elif [ $CMD == 'start' ]
	then
		systemctl start $APPNAME
		systemctl status $APPNAME

	elif [ $CMD == 'stop' ]
	then
		systemctl stop $APPNAME
		systemctl status $APPNAME
    
	
	elif [ $CMD == 'status' ]
	then
		systemctl status $APPNAME


	elif [ $CMD == 'restart' ]
	then
		systemctl restart $APPNAME
		systemctl status $APPNAME

	
	elif [ $CMD == 'enable' ]
	then
		systemctl enable $APPNAME
		systemctl status $APPNAME

	
	elif [ $CMD == 'disable' ]
	then
		systemctl disable $APPNAME
		systemctl status $APPNAME


	elif [ $CMD == 'remove' ]
	then
		remove_service
	
	elif [ $CMD == 'help' ]
	then
		help_message

	elif [ $CMD == 'delcache' ]
	then
		find . | grep -E "(pycache|\.pyc|\.pyo$)" | xargs rm -rf

	else
		echo 'Illegal command. To see list of legal commands, type "bash managebot.sh help"'
		help_message
	fi
else
	echo "Service $APPNAME doesn't exist. To setup it, type 'sudo bash managebot.sh setup'"
	help_message
fi

