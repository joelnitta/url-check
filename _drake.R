# Load packages, functions, and plan
source("R/url_packages.R")
source("R/url_functions.R")
source("R/url_plan.R")

# Specify parallel back-end
options(clustermq.scheduler = "multicore")

# Specify how many slices you want to split the data into.
# - For example, if the original data has 500 rows and you split it
#   into 50 slices, each slice will have 10 rows
n_slices = 50

# Set up drake configuration.
# - Make sure 'jobs' does not exceed the number of cores on your computer!
# - For example, if jobs = 4, four data slices will be processed in parallel 
#   at the same time.
drake_config(
  plan,
  parallelism = "clustermq",
  jobs = 4
)