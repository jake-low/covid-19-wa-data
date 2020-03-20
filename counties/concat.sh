for filename in *.csv; do
  dt=$(basename -s '.csv' $filename)
  cat $filename \
    | sed "1s/^/Date,/; 2,\$s/^/$dt,/"
done
