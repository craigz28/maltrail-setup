# maltrail-setup
Setup script to install dependencies and maltrail.

Malicious traffic detection system (Maltrail)

https://github.com/stamparm/maltrail

1. chmod +x maltrail-setup.sh
2. ./maltrail-setup.sh {sensor.py or server.py} {maltrail server ip address}
3. ex. ./maltrail-setup.sh sensor.py 192.168.1.1
4. ex. ./maltrail-setup.sh server.py 192.168.1.1

Note: Use either sensor.py or server.py and modifications to baseline maltrail.conf will be made accordingly.

Server section modifications include setting up HTTP_ADDRESS, UDP_ADDRESS, UDP_PORT and USE_SERVER_UPDATE_TRAILS.

Sensor section modifications include setting up LOG_SERVER.
