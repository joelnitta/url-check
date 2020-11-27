# url-check

An R project to check (lots of) URLs

This takes a CSV file as input and checks the status of URLs in chunks in parallel.

## Installation

This was built with R version 4.0.2. It may work with other versions, but these have not been tested.

All R packages are tracked and managed with [renv](https://rstudio.github.io/renv/).

The first time the code is run, you may encounter this error if `renv` has not been set up yet:

```
Error in file(filename, "r", encoding = encoding) : 
  cannot open the connection
In addition: Warning message:
In file(filename, "r", encoding = encoding) :
  cannot open file 'renv/activate.R': No such file or directory
```

Set up `renv` as follows and it will go away.

Install `renv`:

```
install.packages("renv")
```

Activate `renv` so it will automatically start when this project is opened.

```
renv::activate()
```

Use `renv` to install all other packages to a private library for this project
(when prompted if you want to proceed, enter 'y'):

```
renv::restore()
```

## Running the code

Place your data file (CSV) in `data/`.

From R, run the following command: `drake::r_make()`.

The results will be saved to `results/url_check_results.csv`

## Modifying the code

- Currently the code splits the input dataframe into 50 slices and checks URLs for each slice in parallel.
To change the number of slices, adjust `slices = 50` in `R/url_plan.R`.

- Currently the code is set up to run 4 processes in parallel using the [clustermq backend](https://books.ropensci.org/drake/hpc.html#the-clustermq-backend).
Change the number of jobs appropriately in `_drake.R` to match the number of cores on your machine. You may also need to [change the backend](https://books.ropensci.org/drake/hpc.html#parallel-backends) depending on your setup.

- Adjust the function `check_urls()` in `R/url_functions.R` as needed depending on the names of the columns containing the URLs to check.