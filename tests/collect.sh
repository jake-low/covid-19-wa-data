set -uo pipefail

for filename in $(find ../updates -name '*.html'); do
  echo "Processing $filename"
  csvfile=$(basename -s .html $filename).raw.csv
  tmpfile=$(mktemp tmp.XXXXXX.csv)

  cat $filename \
    | ../xq '//th/descendant-or-self::*[contains(text(), "Test")]/ancestor-or-self::table'  \
    > $tmpfile

  if [ -s $tmpfile ]; then
    htmltab < $tmpfile > $csvfile
    echo "Wrote CSV $csvfile"
  else
    echo "No data found"
  fi
  rm $tmpfile
done
