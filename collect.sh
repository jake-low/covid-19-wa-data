dt=2020-02-26T00:00:00-08:00 # PST ended march 07 (-8 → -7)
now=$(date +%s)

while [ $(date -d $dt +%s) -le $now ]; do
  echo "pulling data for $dt"
  archivedt=$(
    https --headers https://web.archive.org/web/$(date -d $dt +%Y%m%d)/https://www.doh.wa.gov/Emergencies/Coronavirus \
    | grep -Po 'X-Archive-Redirect-Reason: found capture at \K\d+' \
    | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1-\2-\3T\4:\5:\6/' \
    )

  archivedt=$(date --iso-8601=seconds -d $archivedt)

  echo "found archive with date $archivedt"
  https --follow https://web.archive.org/web/$(date -d $dt +%Y%m%d)/https://www.doh.wa.gov/Emergencies/Coronavirus > $archivedt.html

  # cat $archivedt.html
  #   | ./xq './/table[1]' \
  #   | htmltab \
  #   > $archivedt.csv
  #
  # if [ $(wc -l $archivedt.csv) -eq 0 ]; then
  #   rm $archivedt.csv
  # fi

  echo "downloaded to $archivedt.html successfully"

  dt=$(date --iso-8601=seconds -d "$dt + 6 hours")
done
