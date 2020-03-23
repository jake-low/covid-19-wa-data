# COVID-19 outbreak data for Washington state

This repository contais data I scraped from the Washington DOH website and other sources about the outbreak of COVID-19 (the disease caused by the virus SARS-CoV-2) across the state.

Ready-to-use data is found in `counties/counties.csv` (time-series of cases and deaths by county) and `tests/tests.csv` (time-series of statewide positive and negative test counts).

I'm currently scraping data from the DOH website and regularly pushing updates here. Most of the process is automated by scripts in each directory.

The DOH website only shows the latest numbers. To get numbers for previous days, I scraped the Internet Archive. In a few cases, the Archive didn't have the page I need so I reconstructed the data for that day by hand, by visiting an archived version of the Seattle Times' daily update page and transcribing their graph into CSV format.

`snapshots` contains raw scrapes, named by timestamp. `scrape.js` runs a headless chrome instance to retrieve the page. `scrape.sh` wraps that to run every few hours and save the result.

`updates` contains symlinks to page snapshots. Each symlink is named with a timestamp, but this is the timestamp shown _on the scraped page_, not the timestamp of the scrape itself. You can generate these pages by running `collect.sh` in that directory.

`counties` and `tests` both contain a `collect.sh` script too, that when run (in the appropriate directory!) will extract the appropriate table from each page found in the `updates` directory and dump it to CSV. It uses `xq` (a Python script I wrote to wrap `lxml`'s `elem.xpath()`) and `htmltab` (a tool available [here](https://github.com/flother/htmltab) for converting HTML tables to CSV). You'll also need [xsv](https://github.com/BurntSushi/xsv) installed for munging CSVs, and probably some other dependencies I forgot about (sorry).

Once you run `collect.sh` for either `counties` or `tests` you'll have a bunch of `.raw.csv` files. I've committed cleaned versions of these (`.cleaned.csv`) which have been edited by hand to make formatting consistent. I think this can probably be automated from now on; early CSVs needed a lot of work but the latest versions of the page have been pretty much ready-to-use in raw form.

Once you've got your `.cleaned.csv`s all ready, run `concat.sh` to concatenate them together. This produces a new CSV containing all the data, with an additional `Date` column joined on (the date corresponding to the filename of the CSV that row came from).

# License

Works by me in this repository are [CC0](https://creativecommons.org/share-your-work/public-domain/cc0/).

This repository also contains a few assets that are not my own works and are stored here for data archival purposes only. The JPEG images are from the Seattle Times; I transcribed them manually to CSVs in order to fill holes in the timeseries. The GeoJSON files in the root directory are based on shapefiles published by the U.S. Census. HTML files in the `snapshots` directory are archived from various sources on the web. Do not use any of the resources listed above in a way that would violate the copyright of their creators.
