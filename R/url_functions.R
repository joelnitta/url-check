#' Check the status of a URL
#' 
#' From [wikipedia](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes), 
#' the response codes are as follows:
#' 
#' - 1xx informational response: the request was received, continuing process
#' - 2xx successful:  the request was successfully received, understood, and accepted
#' - 3xx redirection: further action needs to be taken in order to complete the request
#' - 4xx client error: the request contains bad syntax or cannot be fulfilled
#' - 5xx server error: the server failed to fulfil an apparently valid request
#'
#' @param x Input URL
#'
#' @return The status code of the URL. If the URL did not work at all,
#' "no response" is returned.
#'
#' @examples
#' # Inspired by https://stackoverflow.com/questions/52911812/check-if-url-exists-in-r
#' some_urls <- c(
#'   "http://content.thief/",
#'   "doh",
#'   NA,
#'   "http://rud.is/this/path/does/not_exist",
#'   "https://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%3Daps&field-keywords=content+theft", 
#'   "https://www.google.com/search?num=100&source=hp&ei=xGzMW5TZK6G8ggegv5_QAw&q=don%27t+be+a+content+thief&btnK=Google+Search&oq=don%27t+be+a+content+thief&gs_l=psy-ab.3...934.6243..7114...2.0..0.134.2747.26j6....2..0....1..gws-wiz.....0..0j35i39j0i131j0i20i264j0i131i20i264j0i22i30j0i22i10i30j33i22i29i30j33i160.mY7wCTYy-v0", 
#'   "https://rud.is/b/2018/10/10/geojson-version-of-cbc-quebec-ridings-hex-cartograms-with-example-usage-in-r/")
#' purrr::map_chr(some_urls, url_status)
#' 
url_status <- function (x) {
  
  # safe version of httr::HEAD
  sHEAD <- purrr::safely(httr::HEAD)
  
  # safe version of httr::GET
  sGET <- purrr::safely(httr::GET)
  
  # Return NA if input is NA
  if(is.na(x)) return (NA)
  
  # Check URL using HEAD
  # see httr::HEAD()
  # "This method is often used for testing hypertext links for validity, 
  # accessibility, and recent modification"
  res <- sHEAD(x)
  
  # If that returned an error or a non-200 range status (meaning the URL is broken)
  # try GET next
  if (is.null(res$result) || ((httr::status_code(res$result) %/% 200) != 1)) {
    
    res <- sGET(x)
    
    # If neither HEAD nor GET work, it's hard error
    if (is.null(res$result)) return("no response") # or whatever you want to return on "hard" errors
    
    return(httr::status_code(res$result))
    
  } else {
    
    return(httr::status_code(res$result))
    
  }
  
}

#' Check URLs in a dataframe
#'
#' @param data Dataframe with the colums "dc.publisher.uri" and "dc.relation.uri",
#' which each include URLs that need to be validated.
#'
#' @return Dataframe with new columns "dc.publisher.uri.status" and "dc.relation.uri.status"
#' with the [status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) of
#' the URLs in "dc.publisher.uri" and "dc.relation.uri", respectively.
#' 
check_urls <- function(data) {
  data %>%
    dplyr::mutate(
      dc.publisher.uri.status = purrr::map_chr(dc.publisher.uri, url_status),
      dc.relation.uri.status = purrr::map_chr(dc.relation.uri, url_status)
      )
}
