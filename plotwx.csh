#! /bin/csh -f
#Make daily plots of the wind speed and direction.
#25 July 2006 added rainfall plot
##Craig Miller###

set gmtversion = `which psxy`
echo "gmtversion=$gmtversion"
set bindir = /home/volcano/programs/wizmet/bin
set outdir = /home/volcano/output/minidoas
set directiondir = /home/volcano/data/minidoas/wind/direction/`date +%y-%m`
echo $directiondir
set speeddir = /home/volcano/data/minidoas/wind/speed/`date +%y-%m`
echo $speeddir
set raindir = /home/volcano/data/minidoas/rainfall/`date +%y-%m`
echo $raindir
set gmt = /opt/local/gmt/GMT4.3.1/bin

gmtset PAPER_MEDIA A4
gmtset PAGE_ORIENTATION PORTRAIT
gmtset MEASURE_UNIT cm
gmtset INPUT_CLOCK_FORMAT hh:mm:ss INPUT_DATE_FORMAT dd/mm/yyyy
gmtset OUTPUT_CLOCK_FORMAT hh:mm OUTPUT_DATE_FORMAT yyyy-mm-dd
gmtset PLOT_CLOCK_FORMAT hh:mm
gmtset PLOT_DATE_FORMAT dd-mm-yyyy
gmtset TIME_FORMAT_SECONDARY FULL
gmtset TIME_LANGUAGE US
gmtset LABEL_FONT_SIZE 10
gmtset HEADER_FONT_SIZE 16
gmtset HEADER_OFFSET -3
gmtset ANNOT_FONT_SECONDARY 8
gmtset ANNOT_FONT_SIZE_SECONDARY 12

echo "plot mean direction"
#PLOT MEAN WIND DIRECTION
awk ' {print$1"T"$2, $3}' $directiondir/`date -dtoday +%Y%m%d_WD_00.txt` >! winddir.xy
set  R = `$gmt/minmax -H -I1 -f0T,1f winddir.xy`
echo plot MWD $R
$gmt/psxy -JX16T/4 $R -Bsa1DS/0S -Bpa3Hf1h:"time":/a30f15:"wind direction (deg)"::."Mean Wind Direction (DEG)":WSEn -Sc0.1 -GBlue -N -K -U -H winddir.xy >! $outdir/wind.ps

#Add lines at 250 and 315 degrees along time axis.
#echo add lines
#set R2 = -R`date -dtoday +%Y%m%dT00:00`/`date -dtoday +%Y%m%dT23:59`/250/250
#echo $R2
#psxy -JX16T/4  -$R2 -W2t10_10:0 -O -K << Endline>> $outdir/wind.ps 
#`date -dtoday +%Y%m%dT00:00:00` 250
#`date -dtoday +%Y%m%dT23:59:59` 250
#Endline 

rm winddir.xy
 
#PLOT MEAN WIND SPEED
echo "plot mean wind speed"
awk ' {print$1"T"$2, $3}' $speeddir/`date -dtoday +%Y%m%d_WS_00.txt` >! windspeed.xy
set  R = `$gmt/minmax -H -I1 -f0T,1f windspeed.xy`
echo plot MWS $R

$gmt/psxy -JX16T/4 $R -Bsa1DS/0S -Bpa3Hf1h/a2f1:"wind speed (m/s)"::."Mean Wind Speed (m/s)":WsEN -Sc0.1 -GBlue -O -Y4.5 -H -N windspeed.xy >> $outdir/wind.ps
rm windspeed.xy

#PLOT RAINFALL Note: only plots if there has been rain.
echo "plot rainfall"
awk 'BEGIN {FS=" "}{if($3 >= 0.05) {print$1"T"$2, $3} else print$1"T"$2, "0"}' $raindir/`date -dtoday +%Y%m%d_rain.txt` >! rainT.xy

if ( -s rainT.xy ) then
set  R = `$gmt/minmax -H -I1 -f0T,1f rainT.xy`
echo plot MWS $R
$gmt/psxy -JX16T/4 $R -Bsa1DS/0S -Bpa3Hf1h/a1f0.5:"Rainfall (mm)"::."Daily Rainfall (mm)":WSEN -Sc0.1 -GBlue -U -Y4.5 -N rainT.xy >! $outdir/rain.ps

$bindir/pstogif.pl $outdir/rain 300
cp $outdir/rain.gif /opt/local/apache/htdocs/volcanoes/whiteis/minidoas/rainfall
cp $outdir/rain.gif /opt/local/apache/htdocs/volcanoes/whiteis/minidoas/rainfall/`date -dtoday +%Y%m%d_rain.gif`
#rm rainT.xy
else
echo "no rain today"
endif



#ps conversion and copy to webserver on pihanga
/home/volcano/bin/pstogif.pl $outdir/wind 300
cp $outdir/wind.gif /opt/local/apache/htdocs/volcanoes/whiteis/minidoas/wind
cp $outdir/wind.gif /opt/local/apache/htdocs/volcanoes/whiteis/minidoas/wind/`date -dtoday +%Y%m%d_wind.gif`

#for tour operators
cp $outdir/wind.gif /home/volcano/web_page/WhiteIs
#$bindir/pstogif.pl $outdir/rain 300

