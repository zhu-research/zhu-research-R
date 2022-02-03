#' @title Read AirNow data
#' @description Simple function to read AQS data files downloaded by the function download_airnow, rename columns, and convert from wide to long data
#' @param airnow Character vector AirNow file name. Can be length 1 or longer.
#' @param wide Boolean of whether you want the data in wide (TRUE) or long (FALSE) format. Default is FALSE (long data)
#' @importFrom data.table fread rbindlist
#' @import tidyr
#' @import dplyr
#' @export


read_airnow <- function(airnow, wide = F) {

  requireNamespace("tidyr")
  requireNamespace("dplyr")

  if(length(airnow) == 1) {

    df <- data.table::fread(airnow)

    names(df) <- c("date", "time", "AQS_ID", "name", "timezone", "pollutant", "unit", "measurement", "agency")

    if(wide) {

      df <- df %>%
        dplyr::select(!unit) %>%
        tidyr::pivot_wider(names_from = "pollutant", values_from = "measurement", values_fill = NA)

    }
  } else {

    df <- lapply(airnow, function(x) {

      x2 <- fread(x)

      names(x2) <- c("date", "time", "AQS_ID", "name", "timezone", "pollutant", "unit", "measurement", "agency")

      if(wide) {
        x2 <- x2 %>%
          dplyr::select(!unit) %>%
          tidyr::pivot_wider(names_from = "pollutant", values_from = "measurement", values_fill = NA, )

      }

      return(x2)

    }) %>%
      data.table::rbindlist(fill = T)
  }

  return(df)

}
