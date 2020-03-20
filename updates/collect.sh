set -euo pipefail

for filename in $(find ../snapshots -name '*.html'); do
  echo "Processing $filename"

  updated=$(
    cat $filename \
    | ../xq '//*[contains(text(), "Last updated:")] | //*[contains(text(), "Updated on")]' \
    | w3m -I utf8 -O utf8 -T text/html -o pseudo_inlines=0 -dump \
    | cut -d ' ' -f3- \
    | sed 's/\bat //'
  )

  dt=$(env TZ="America/Los_Angeles" date --iso-8601=minutes -d "$updated")

  echo $updated → $dt

  if [ ! -L $dt.html ]; then
    ln -s $filename $dt.html
    echo "Created link $dt.html"
  fi
done
