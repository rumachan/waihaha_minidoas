#!/bin/csh -f

#getspectra.csh

# This script gets the current day's minidoas spectra data from 161.65.63.240
# (Windows server 'Putney' in Whakatane) and puts it in the correct 
# directories on the volcano account.

echo Start of getspectra.csh - Get MiniDOAS Spectra:
# set default directories and filenames, etc:
# NE=North East Point station, SR=South Rim station
set ping = /bin/ping
set NEdatadir = /home/volcano/data/minidoas/spectra/NE
set SRdatadir = /home/volcano/data/minidoas/spectra/SR
set prog_directory = /home/volcano/programs/minidoas
set remote_machine = 161.65.63.240 
set local_machine = volcano
set NEFile = "NE_`date +%Y%m%d`.zip"
set SRFile = "SR_`date +%Y%m%d`.zip"
echo NE File: $NEFile
echo SR File: $SRFile


# Ping remote_machine to check alive: 
$ping -c 5 $remote_machine > /dev/null    	      # ping timeout 5 sec
if ($status != 0) then                                # dead so exit
	echo Cannot talk to $remote_machine!
	exit 1
endif

# WGET file transfer Method: 

# Get data from NE:
echo Starting WGET for NE
cd $NEdatadir
wget -v -N -nH "ftp://$remote_machine/spectra/NE/$NEFile"


# Get data from SR:
echo Starting WGET for SR
cd $SRdatadir
wget -v -N -nH "ftp://$remote_machine/spectra/SR/$SRFile"



