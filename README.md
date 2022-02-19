# zhu-research-R
R scripts and packages for use among Dr. Yifang Zhu's lab

## Installation

`devtools::install_github("zhu-research/zhu-research-R/zhuResearch")`

## Current functions

`download_airnow`: Simple function to download data from EPA's airnow database. Inputs a start and end date; downloads data between the two dates (inclusive) in the working directory

`read_airnow`: Read in files downloaded using `download_airnow`. Can read in multiple files at once and includes an option to convert from long to wide data.

`pems_login`: A wrapper for RSelenium that opens and logs into the CalTrans PeMS database. Users need to supply their own credentials, which can be obtained by contacting CalTrans directly. This function requires a Docker installation. Depending on internet connection, Docker, and the CalTrans website, logging in can be a little bit inconsistent, but repeating attempts should work. 

`get_pems_id`: Given a set of coordinates, scrapes the CalTrans PeMS database to collect the IDs and (optionally) GPS coordinates of nearby traffic detectors. Requires logging in to PeMS, which can be done with `pems_login`.

## Note

The above functions were written for personal projects, and might be a little unpolished. Authors don't have too much capacity for support, so use at your own risk.
