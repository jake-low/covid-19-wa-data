for filename in *.cleaned.csv; do
  dt=$(basename -s '.cleaned.csv' $filename)
  tmpfile=$(mktemp tmp.XXXXXX.csv)

  cat $filename \
    | xsv select "County,Cases,Deaths" \
    | sed "1s/^/Date,/; 2,\$s/^/$dt,/" \
    > $tmpfile
done

xsv cat rows tmp.*.csv | xsv sort -s 1 > counties.csv
rm tmp.*.csv
