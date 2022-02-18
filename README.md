# zhu-research-R
R scripts and packages for use among Dr. Yifang Zhu's lab

## Installation

`devtools::install_github("zhu-research/zhu-research-R/zhuResearch")`

## Current functions

`download_airnow`: Simple function to download data from EPA's airnow database. Inputs a start and end date; downloads data between the two dates (inclusive) in the working directory

`read_airnow`: Read in files downloaded using `download_airnow`. Can read in multiple files at once and includes an option to convert from long to wide data.
