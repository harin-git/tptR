# Timbre Perception Test (TPT)

This is an R package for running TPT, implemented using psychTestR.
The TPT is a test to measure an individual's ability on timbre perception.

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
x$packages[x$packages$package %in% c("mpt", "psychTestR"), ]
```

## Standalone Installation (local use)

1. If you don't have R installed, install it from here: https://cloud.r-project.org/

2. Open R.

3. Install the ‘devtools’ package with the following command:

`install.packages('devtools')`

4. Install the tptR:

`devtools::install_github('harin-git/tptR')`

