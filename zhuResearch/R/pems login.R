#' @title Log into PeMS
#' @description Set up RSelenium and log into PeMS. Requires a Docker to be installed before running!
#' @param user Username or email address to log into PeMS account
#' @param pass Password to log into PeMS account
#' @param port_no Port number to be used by RSelenium, 4445 by default. Only change if necessary!
#' @import RSelenium

pems_login <- function(user, pass, port_no = 4445L) {

  term_id <- rstudioapi::terminalExecute(command = paste0("docker run -d -p", port_no, ":4444 --shm-size=256m selenium/standalone-chrome"))

  remDr <- RSelenium::remoteDriver(remoteServerAddr = "localhost",
                                   port = port_no,
                                   browserName = "chrome")
  remDr$open()

  remDr$navigate("http://pems.dot.ca.gov")

  username <- remDr$findElement(using = "xpath", value = '//*[@id="username"]')
  username$sendKeysToElement(list(user))

  password <- remDr$findElement(using = "xpath", value = '//*[@id="password"]')
  password$sendKeysToElement(list(paste0(pass, ", \uE007")))

  remDr$screenshot()
}
