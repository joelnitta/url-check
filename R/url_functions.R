# safe version of httr::HEAD
sHEAD <- purrr::safely(httr::HEAD)

# safe version of httr::GET
sGET <- purrr::safely(httr::GET)

# Check if a URL exists.
# A return value in the 200 range is a valid URL
url_exists <- function(x, non_2xx_return_value = FALSE, quiet = FALSE, ...) {
  
  # Return NA if input is NA
  if(is.na(x)) return (NA)
  
  # Try HEAD first since it's lightweight
  res <- sHEAD(x, ...)
  
  if (is.null(res$result) || 
      ((httr::status_code(res$result) %/% 200) != 1)) {
    
    res <- sGET(x, ...)
    
    if (is.null(res$result)) return(FALSE) # or whatever you want to return on "hard" errors
    
    if (((httr::status_code(res$result) %/% 200) != 1)) {
      if (!quiet) warning(sprintf("Requests for [%s] responded but without an HTTP status code in the 200-299 range", x))
      return(non_2xx_return_value)
    }
    
    return(TRUE)
    
  } else {
    return(TRUE)
  }
}

check_url <- function(data) {
  data %>%
    mutate(
      dc.publisher.uri.exists = map_lgl(dc.publisher.uri, ~url_exists(., quiet = TRUE)),
      dc.relation.uri.exists = map_lgl(dc.relation.uri, ~url_exists(., quiet = TRUE))
      )
}
