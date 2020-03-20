set -euo pipefail

for filename in $(find ../updates -name '*.html'); do
  echo "Processing $filename"
  csvfile=$(basename -s .html $filename).raw.csv

  cat $filename \
    | ../xq '//th/descendant-or-self::*[contains(text(), "County")]/ancestor-or-self::table' \
    | htmltab \
    > $csvfile

  echo "Wrote CSV $csvfile"
done
