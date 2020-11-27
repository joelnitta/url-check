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
To change the number of slices, adjust `slices = 50` in [`R/url_plan.R`](https://github.com/joelnitta/url-check/blob/608ed340481430d7db8d005e86908d43cf6d297d/R/url_plan.R#L11).

- Currently the code is set up to run 4 processes in parallel using the [clustermq backend](https://books.ropensci.org/drake/hpc.html#the-clustermq-backend).
Change the number of jobs appropriately in [`_drake.R`](https://github.com/joelnitta/url-check/blob/608ed340481430d7db8d005e86908d43cf6d297d/_drake.R#L16) to match the number of cores on your machine. You may also need to [change the backend](https://books.ropensci.org/drake/hpc.html#parallel-backends) depending on your setup.

- Adjust the function `check_urls()` in [`R/url_functions.R`](https://github.com/joelnitta/url-check/blob/608ed340481430d7db8d005e86908d43cf6d297d/R/url_functions.R#L76) as needed depending on the names of the columns containing the URLs to check.

## Restarting after a crash

The results for each data slice will be saved as they finish, so if R crashes part way through, you can just run `drake::r_make()` again and it will start from the point where it crashed without starting all over again.

In that case, you might see an error like this one when you run `drake::r_make()`:

```
Error: callr subprocess failed: drake's cache is locked.
Read https://docs.ropensci.org/drake/reference/make.html#cache-locking
or force unlock the cache with drake::drake_cache("/Users/joelnitta/repos/url-check/.drake")$unlock()
```

As the error says, run `drake::drake_cache("/Users/joelnitta/repos/url-check/.drake")$unlock()` (the path to `.drake` will be different) to unlock the cache, then you can run `drake::r_make()` again.
