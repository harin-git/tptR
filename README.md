# Timbre Perception Test (TPT)
The TPT is a test to measure an individual's ability on timbre perception.
This R package is for running the TPT locally and it is implmented using [psychTestR](https://github.com/pmcharrison/psychTestR), a package for 
designing and running psychological experiments with R.

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

You can simply run experiments locally by setting the admin password and researcher email to display to the participants.

``` r
library(tptR)
tptR::TPT_standalone(password, researcher_email)

# For example:
tptR::TPT_standalone("1234", "john@gmail.com")
```

## Interpreting results
Once participants complete the experiment locally, the data is stored in the "output" folder. Inside the "output/results" you will find all recorded sessions.

Participant's performance scores are recorded in three ways:

1. Column names starting with "raw ..." shows the raw slider values the participant positioned for the particular trial.

2. Column names starting with "abs ..." shows the absolute values of *raw value - target value* (i.e. absolute slider distance from the target position).

3. Column names starting with "bin ..." shows the calculated bin scores out of 6 very similar to the method discussed in the paper. We recommend using these bin scores rather than absolute values.

Aggregated TPT scores:

> For convenience, the results table includes mean scores for each of the three testing blocks (e.g. tpt_env_score). These are aggregated based on the bin scores and then converted into scores out of 100. The general score (i.e. tpt_general_score) is also reported by taking the mean across all blocks.


