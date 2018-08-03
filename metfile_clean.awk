#########################################################################
# AWK Code to tidy up White Island Met data files:
#   * Removes spaces from the line
#   * Removes lines containing "NZWIX" (these lines have no data)
#   * Replaces empty fields in remaining lines with 0, UNLESS the
#     missing value is wind speed or wind direction, in which case the
#     entire line is ignored (since we need a valid wind speed and
#     direction for the MiniDoas).
#
# Usage Example (e.g. in Shell script):
#  awk -F"," -f"/home/volcano/programs/minidoas/metfile_clean.awk" $infile > $infile_clean
#
# J Cole-Baker / GNS Science / Jan 2010
#
#########################################################################

{
n = match( $0, "NZWIX" ) 
if (n == 0)
  {
  if (($4 != "") && ($8 != ""))
    {

    for (i = 1; i <= NF; i=i+1) 
      { 
      gsub(" ","",$i)
      if ($i == "") 
        { 
        printf "0" 
        }
      else 
        { 
        printf "%s",$i; 
        } 
 
      if (i < NF) printf "," 
      } 
    printf "\n" 

    }
  }
}
