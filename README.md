# Timbre Perception Test (TPT)
The TPT is a test to measure an individual's ability on timbre perception.
This R package is for running the TPT locally and it is implmented using [psychTestR](https://github.com/pmcharrison/psychTestR), a package for 
designing and running psychology experiments with R.

## Citation

The TPT is introduced in the following paper:

> Lee, H., & Müllensiefen, D. (2020). The Timbre Perception Test (TPT): A new interactive musical assessment tool to measure timbre perception ability. Attention, Perception, & Psychophysics, 82(7), 3658–3675. https://doi.org/10.3758/s13414-020-02058-3

We advise mentioning the software versions you used,
in particular the versions of the `tptR` and `psychTestR` packages.
You can find these version numbers from R by running the following commands:

``` r
library(tptR)
library(psychTestR)
if (!require(devtools)) install.packages("devtools")
x <- devtools::session_info()
x$packages[x$packages$package %in% c("tptR", "psychTestR"), ]
```

## Standalone Installation (local use)

1. If you don't have R installed, install it from here: https://cloud.r-project.org/

2. Open R.

3. Install the ‘devtools’ package with the following command:

`install.packages('devtools')`

4. Install the tptR:

`devtools::install_github('harin-git/tptR')`

## Usage

The package comes with two functions

1. To run TPT experiment locally 

``` r
library(tptR)
tptR::TPT_test(password, researcher_email)
```

2. For performing posterior analyses

``` r
library(tptR)
tptR::TPT_analyse(data_path, bin_scoring = TRUE)
```

