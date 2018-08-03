#!/bin/csh -f
# This script gets the wind speed and direction data for the minidoas.  Data is put in /home/volcano/data/minidoas/wind
####Craig Miller June 2006###
# 25 july added rainfall to script

# 22-Jan-2010:
# Created an AWK script to clean up input files. Replaces the old grep line (see below). 
#   -Jeremy C-B 
# 

set infile = /home/volcano/data/nzwix/nzwix_data_NZTIME.csv
set infile_clean = /home/volcano/data/minidoas/weatherfile.csv
set directiondir = /home/volcano/data/minidoas/wind/direction
set speeddir = /home/volcano/data/minidoas/wind/speed
set raindir = /home/volcano/data/minidoas/rainfall
set yesterday = `date -dyesterday +%d/%m/%Y`
set today = `date -dtoday +%d/%m/%Y`
echo $yesterday
set month = `date +%y-%m`
echo $month

######### Old grep-based file cleaning method. ##########
#remove non data from datafile.
#more $infile | grep -v NZWIX >! $infile_clean
#more $infile | grep -v '\,\,' >! $infile_clean     # New Grep pattern to remove any lines with missing fields (finds ",,"). 

# New awk-based file clean. Removes NZWIX lines and fixes missing fields in other lines so that weather data
# can still be extracted. 
# Uses an awk script saved in metfile_clean.awk
awk -F"," -f"/home/volcano/programs/minidoas/metfile_clean.awk" $infile > $infile_clean

#MAKE WIND DIRECTION FILE

cd $directiondir
test -d $month || mkdir $month
cd $month
echo `pwd`

sed 's/,/ /g' $infile_clean >! $directiondir/WD.xy

awk -v date="$today" '$1 ~ date {print $1, $2,"	"$8}' $directiondir/WD.xy >! $directiondir/WD_new.xy

awk ' BEGIN {FS = "" ; print "Time	Wind dir. (deg)" }; { print $1$2"/"$4$5"/"$7$8$9$10$11$12$13$14$15$16$17$18$19$21$22$23$24$25$26$27$28$29$30}' $directiondir/WD_new.xy >! $directiondir/$month/`date -dtoday +%Y%m%d_WD_00.txt`

unix2dos $directiondir/$month/`date -dtoday +%Y%m%d_WD_00.txt`

#MAKE WIND SPEED FILE

cd $speeddir
test -d $month || mkdir $month
cd $month
echo `pwd`

sed 's/,/ /g' $infile_clean >! $speeddir/WS.xy

awk -v date="$today" ' $1 ~ date {print $1, $2,"	" $4*0.51444}' $speeddir/WS.xy >! $speeddir/WS_new.xy


awk 'BEGIN { FS = "" ; print "Time	Wind speed (m/s)" }; { print $1$2"/"$4$5"/"$7$8$9$10$11$12$13$14$15$16$17$18$19$21$22$23$24$25$26$27$28$29$30 }' $speeddir/WS_new.xy >! $speeddir/$month/`date -dtoday +%Y%m%d_WS_00.txt`
###

unix2dos $speeddir/$month/`date -dtoday +%Y%m%d_WS_00.txt`



#MAKE RAINFALL FILE
                                                                                                         
cd $raindir
test -d $month || mkdir $month
cd $month
echo `pwd`
                                                                                                                             
sed 's/,/ /g' $infile_clean >! $raindir/rain.xy
                                                                                                                             
awk -v date="$today" ' $1 ~ date {print $1, $2,"    " $14}' $raindir/rain.xy >! $raindir/$month/`date -dtoday +%Y%m%d_rain.txt`
                                                                                                                             
unix2dos $raindir/$month/`date -dtoday +%Y%m%d_rain.txt`


###Make Max Gust Wind Speed file###

cd $speeddir
test -d $month || mkdir $month
cd $month
echo `pwd`
 
sed 's/,/ /g' $infile_clean >! $speeddir/WS_max.xy
 awk -v date="$today" ' $1 ~ date {print $1, $2,"    ""\t"$6*0.51444}' $speeddir/WS_max.xy >! $speeddir/WS_max_new.xy
 awk 'BEGIN { FS = "" ; print "Time	Wind speed Max Gust (m/s)" }; { print $2"/"$5"/"$7$8$9$10$11$12$13$14$15$16$17$18$19$25$26$27$28$29$30 }' $speeddir/WS_max_new.xy >! $speeddir/$month/`date -dtoday +%Y%m%d_WS_00_max.txt`
 unix2dos $speeddir/$month/`date -dtoday +%Y%m%d_WS_00_max.txt`

###Make max gust wind dir file##

cd $directiondir
test -d $month || mkdir $month
cd $month
echo `pwd`
 
sed 's/,/ /g' $infile_clean >! $directiondir/WD_max.xy
 
awk -v date="$today" '$1 ~ date {print $1, $2,"     ""\t"$9}' $directiondir/WD_max.xy >! $directiondir/WD_new_max.xy
 
awk ' BEGIN {FS = "" ; print "Time	Wind dir. Max Gust (deg)" }; { print $2"/"$5"/"$7$8$9$10$11$12$13$14$15$16$17$18$19$26$27$28$29$30 }' $directiondir/WD_new_max.xy >! $directiondir/$month/`date -dtoday +%Y%m%d_WD_00_max.txt`
 
unix2dos $directiondir/$month/`date -dtoday +%Y%m%d_WD_00_max.txt`
