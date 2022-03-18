#' @title Log into PeMS
#' @author Jonathan Liu
#' @description Set up RSelenium and log into PeMS. Requires a valid PeMS account (see https://pems.dot.ca.gov/). Requires a Docker (https://www.docker.com/) to be installed and running. Usage can be a little unreliable depending on internet connection, Docker, and the PeMS website. If it takes too long to connect to the server or you get an error, wait a little and try again.
#' @param user Username or email address to log into PeMS account
#' @param pass Password to log into PeMS account
#' @param port_no Port number to be used by RSelenium, 4445 by default. Only change if necessary!
#' @import RSelenium
#' @import rvest
#' @export

pems_login <- function(user, pass, new_port = F, port_no = 4445L) {

  if(new_port) {
    term_id <- rstudioapi::terminalExecute(command = paste0("docker run -d -p", port_no, ":4444 --shm-size=256m selenium/standalone-chrome"))
  }

  remDr <- RSelenium::remoteDriver(remoteServerAddr = "localhost",
                                   port = port_no,
                                   browserName = "chrome")
  remDr$open()

  remDr$navigate("http://pems.dot.ca.gov")

  username <- remDr$findElement(using = "xpath", value = '//*[@id="username"]')
  username$sendKeysToElement(list(user))

  password <- remDr$findElement(using = "xpath", value = '//*[@id="password"]')
  password$sendKeysToElement(list(paste0(pass, ", \uE007")))

  remDr$screenshot(display = T)

  return(remDr)
}
