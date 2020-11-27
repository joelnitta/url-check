plan <- drake_plan(
  
  # Read in data frame of URLs to check
  urls_to_check = read_csv("data/Sample_500.csv"),
  
  # Check the URLs in slices of data in parallel
  # - For example, if the original data has 500 rows and you split it
  #   into 50 slices, each slice will have 10 rows
  url_results_each = target(
    check_urls(urls_to_check),
    transform = split(urls_to_check, slices = 50)
  ),
  
  # Combine the results into single dataframe
  url_results_combined = target(
    bind_rows(url_results_each),
    transform = combine(url_results_each),
  ),
  
  # Write out the final results
  url_results_out = write_csv(url_results_combined, "results/url_check_results.csv")
  
)