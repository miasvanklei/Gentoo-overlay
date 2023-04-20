#!/bin/bash
sbsign --key /etc/keys/MOK.key --cert /etc/keys/MOK.crt --output $2 $2
