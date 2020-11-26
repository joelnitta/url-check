# Load packages and functions
source("R/url_packages.R")
source("R/url_functions.R")
source("R/url_plan.R")

# Specify parallel back-end
options(clustermq.scheduler = "multicore")

# Set up drake configuration.
# - Make sure 'jobs' does not exceed the number of cores on your computer!
# - For example, if jobs = 4, four data slices will be processed in parallel 
#   at the same time.
drake_config(
  plan,
  parallelism = "clustermq",
  jobs = 4
)