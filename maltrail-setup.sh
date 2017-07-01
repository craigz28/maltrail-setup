#!/usr/bin/env bash

set -e
set -u

function usage {
	echo "Usage:"
	echo "$0 {sensor.py or server.py} {IP address}"
	echo "Example: ./maltrail-setup.sh sensor.py 192.168.2.100"
	exit 1
}

# Check for arguments
if [[ $# -gt 2 || $# -lt 2 ]]; then
    usage
fi

FILE=$1
IP=$2

# Install dependencies and download Maltrail
sudo apt -y install git python-pcapy
git clone https://github.com/stamparm/maltrail.git
sudo apt -y install schedtool

# Set IP address in server section of maltrail configuration file
if [ $1 = "server.py" ]; then
    sed -i '4s/.*/HTTP_ADDRESS '$2'/' $PWD/maltrail/maltrail.conf
    sed -i '23s/.*/UDP_ADDRESS '$2'/' $PWD/maltrail/maltrail.conf
    sed -i '26s/.*/UDP_PORT 8337/' $PWD/maltrail/maltrail.conf
    sed -i '29s/.*/USE_SERVER_UPDATE_TRAILS true/' $PWD/maltrail/maltrail.conf
fi

# Set IP address in sensor section of maltrail configuration file
if [ $1 = "sensor.py" ]; then
    sed -i '69s/.*/LOG_SERVER '$2':8337/' $PWD/maltrail/maltrail.conf
    sed -i '78s/.*/UPDATE_SERVER http:\/\/'$2':8338\/trails/' $PWD/maltrail/maltrail.conf
fi

# Install supervisor to start server.py or sensor.py
sudo apt -y install supervisor

# Create configuration file for supervisor
sudo echo "[program:maltrail_script]" >> /etc/supervisor/conf.d/maltrail.conf
sudo echo "command=sudo python $PWD/maltrail/$FILE" >> /etc/supervisor/conf.d/maltrail.conf
sudo echo "autostart=true" >> /etc/supervisor/conf.d/maltrail.conf
sudo echo "autorestart=true" >> /etc/supervisor/conf.d/maltrail.conf
sudo echo "stderr_logfile=/var/log/maltrail.err.log" >> /etc/supervisor/conf.d/maltrail.conf
sudo echo "stdout_logfile=/var/log/maltrail.out.log" >> /etc/supervisor/conf.d/maltrail.conf

# Initialize supervisor and start maltrail
sudo supervisorctl reread
sudo supervisorctl update
