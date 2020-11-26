plan <- drake_plan(
  
  # Read in data frame of URLs to check
  urls_to_check = read_csv("data/Sample_500.csv"),
  
  # Check the URLs in slices of data so R doesn't crash
  # (n_slices is set by _drake.R)
  url_results_each = target(
    check_url(urls_to_check),
    transform = split(urls_to_check, slices = n_slices)
  ),
  
  # Combine the results into single dataframe
  url_results_combined = target(
    bind_rows(url_results_each),
    transform = combine(url_results_each),
  ),
  
  # Write out the final results
  url_results_out = write_csv(url_results_combined, "url_results.csv")
  
)