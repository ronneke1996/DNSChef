#!/bin/bash

if [ ! -f chef.ini ]; then
    echo -e "chef.ini file missing!"
    exit 1
fi

# Creating directory
mkdir /opt/dnschef

#  Move files to directory
cp dnschef.py /opt/dnschef/
cp chef.ini /opt/dnschef/
cp requirements.txt /opt/dnschef/

# Install dependencies
virtualenv /opt/dnschef/venv
/opt/dnschef/venv/bin/python -m pip install -r requirements.txt
rm /opt/dnschef/requirements.txt

# Install service
cp ./tools/dnschef.service /etc/systemd/system/

# Enable and start service
systemctl daemon-reload
systemctl enable dnschef.service
systemctl start dnschef.service
