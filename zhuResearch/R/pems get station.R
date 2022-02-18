#' @title Scrap PeMS Station IDs
#' @author Jonathan Liu
#' @description Look up PeMS station IDs, given a longitude and latitude. Requires a PeMS account, a Docker instance, and running pems_login first.
#' @param lat Latitude
#' @param lon Longitude
#' @param pages Number of pages to scrape from PeMS website. Default is 5 pages
#' @param remdr RSelenium remote driver from pems_login
#' @param wait_time Time to wait between page loads on the PeMS website. Default is 4 seconds. Adjust based on strength of internet connection.
#' @param gps boolean of whether or not you want GPS coordinates in addition to station IDs. Can be slow, default is FALSE (no GPS)
#' @import rvest
#' @import xml2
#' @import data.table
#' @import stringr
#' @export


get_pems_id <- function(lat = 33.819318, lon = -117.918775, pages = 5, remdr, wait_time = 4, gps = F) {

  # function scraping VDS IDs from webpage, to be used later
  get_HTML_info <- function(html) {

    begin <- "/?station_id="
    end <- "&dnode=VDS"

    pages_data <- html %>%
      html_nodes("a.srch_match_small")

    pg1_table <- bind_rows(lapply(xml_attrs(pages_data), function(x) data.frame(as.list(x), stringsAsFactors=FALSE)))[[2]]

    pg1_table <- pg1_table[pg1_table %like% "VDS"]
    pg1_table <- unlist(strsplit(pg1_table, end))
    pg1_table <- unlist(strsplit(pg1_table, begin))
    pg1_table <- pg1_table[!pg1_table %in% "/?"]

    return(pg1_table)
  }

  # function to get GPS coordinates of a given VDS station, to be used later
  get_gps <- function(id) {

    # navigate to URL
    station_page <- paste0("http://pems.dot.ca.gov/?station_id=", id,"&dnode=VDS")
    remdr$navigate(station_page)

    # locating the desired table
    html.table <- remdr$findElement(using = "xpath", '//*[@id="segment_context_box"]/table[2]')

    # scrape
    html.table <- html.table$getElementAttribute("outerHTML")[[1]] %>%
      read_html() %>%
      html_table() %>%
      data.frame(.)

    # rename/cleaning up
    names(html.table) <- html.table[2,]

    lat <- html.table$Lat[length(html.table$Lat)]
    lon <- html.table$Lng[length(html.table$Lng)]

    latlon <- data.frame(VDS = id, latitude = lat, longitude = lon)

    return(latlon)
  }



  pages <- as.character(1:pages)

  search_url <- paste0("http://pems.dot.ca.gov/?dnode=search&content=solr_search&view=m&qy=", lat,"%2C+", lon)

  remdr$navigate(search_url)

  search_result_pages <- lapply(pages, function(x) {

    x2 <- remdr$getPageSource()[[1]]

    remdr$findElement(using = "link text", value = "Next >>")$clickElement()
    Sys.sleep(wait_time)

    print(paste("Page", x))

    return(x2)

  }) %>%
    lapply(read_html) %>%
    lapply(get_HTML_info) %>%
    unlist()

  if(gps) {
    search_result_pages <- lapply(search_result_pages, get_gps) %>%
      rbindlist()
  }

  return(search_result_pages)

}
