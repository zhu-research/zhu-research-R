#' @title Download AirNow data
#' @description function to download AirNow data, currently only works for dates in the same year
#' @param start_date The starting date in "YYYY-MM-DD" format
#' @param end_date The ending date in "YYYY-MM-DD" format
#' @name download_airnow
#' @import lubridate
#' @import stringr
#' @export
#' @examples
#' download_airnow("2020-01-01", "2020-02-01")
#' download_airnow("2019-08-10", "2019-12-10")


requireNamespace("lubridate") # R package for handling dates easily
requireNamespace("stringr")   # R package for handling strings easily

# input start_date and end_date as "YYYY-MM-DD", including quotation marks, such as "2020-12-30"

download_airnow <- function(start_date, end_date) {

  # sample AirNow URL: https://s3-us-west-1.amazonaws.com//files.airnowtech.org/airnow/2018/20180101/HourlyData_2018010100.dat
    # there are three parts we need to input ourselves:
      # 1. year
      # 2. year month date
      # 3. year month date hour

  # format start and end dates into the date format to create an interval
  start_date <- as_date(start_date)
  end_date <- as_date(end_date)

  # get the interval of dates between the start and end date
  date_interval <- as_date(start_date:end_date)

  # remove the dashes, which we do not need
  date_interval <- str_remove_all(date_interval, "-")

  # extract the year
  year <- year(start_date)

  # on AirNow, hour values range from 00 to 23
  # paste0: paste without a separator
  hours <- c(paste0("0", 1:9), # single digit numbers require a 0 preceeding the digit
             10:23)

  # combine the hours and dates within the date interval with sapply ("s apply")
  year_month_date_hours <- sapply(date_interval, paste0, hours)

  # get year month date without the hour, which means deleting the last two characters from the strong
  year_month_date <- substr(year_month_date_hours, 1, nchar(year_month_date_hours) - 2)

  ### Constructing the URL
  url_base <- "https://s3-us-west-1.amazonaws.com//files.airnowtech.org/airnow/"

  url_to_download <- paste0(url_base, # base URL component
                            year, "/", year_month_date, # year and year/month/date (parts 1 and 2)
                            "/HourlyData_", year_month_date_hours, ".dat" # adding in the actual file name
  )

  # for loop to download at all of the URLs

  for(i in 1:length(url_to_download)) {

    download.file(url_to_download[i], destfile = paste0(year_month_date_hours[i], ".dat"))

    }

}

# test
