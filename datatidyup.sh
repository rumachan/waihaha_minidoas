#! /bin/csh -f
#This script deletes spectra files older than 5 months to keep disk space under control on pihanga.
#Data is copied onto the geonet storage array every week if older data is needed.

foreach station (NE SR)
	set datadir = /home/volcano/data/minidoas/spectra
	set date = `date -d -5months +%Y%m%d`

cd $datadir/$station/

#echo delete $station"_"$date.zip

rm -f $station"_"$date.zip
end

