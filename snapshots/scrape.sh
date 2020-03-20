set -euo pipefail

chrome="/Applications/Chrome.app/Contents/MacOS/Google Chrome"

trap "exit" INT TERM
trap "kill 0" EXIT

while true; do
  dt=$(date --iso-8601=seconds)
  echo "Waking up at $dt to scrape page"

  "$chrome" --headless --remote-debugging-port=9222 https://chromium.org &
  sleep 5
  node scrape.js > $dt.html
  kill $(jobs -pr)

  if [ $(wc -c $dt.html) -lt 25000 ]; then
    echo "Failed? File size unexpectedly small."
  else
    echo "Succeessfully scraped page."
  fi

  sleep 3h
done
