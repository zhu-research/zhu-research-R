#' @title Read AirNow data
#' @description Simple function to read AQS data files downloaded by the function download_airnow, rename columns, and convert from wide to long data
#' @param airnow Character vector AirNow file name. Can be length 1 or longer. Merges multiple files together if length is greater than 1.
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

    pollutants <- unique(df$pollutant)

    if(wide) {

      df <- df %>%
        dplyr::select(!unit) %>%
        tidyr::pivot_wider(names_from = "pollutant", values_from = "measurement", values_fn = mean)

      df[df == "NULL"] <- NA

      for(i in 1:length(pollutants)) {
        df[[pollutants[i]]] <-  df[[pollutants[i]]] %>%
          unlist()
      }

    }
  }   else {
    df <- lapply(airnow, function(x) {
      x2 <- fread(x)
      names(x2) <- c("date", "time", "AQS_ID", "name",
                     "timezone", "pollutant", "unit", "measurement",
                     "agency")
      pollutants <- unique(x2$pollutant)

      if (wide) {
        x2 <- x2 %>% dplyr::select(!unit) %>% tidyr::pivot_wider(names_from = "pollutant",
                                                                 values_from = "measurement", values_fn = mean)
      }

      for (i in 1:length(pollutants)) {
        df[,pollutants[i]] <- df[,pollutants[i]] %>% unlist()
      }

      return(x2)
    }) %>% data.table::rbindlist(fill = T)

    df[df == "NULL"] <- NA

  }


  return(df)

}

# tst
