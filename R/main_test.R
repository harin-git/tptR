#' @export


## Online directories
audio <- "https://hleetestbuck.s3.eu-central-1.amazonaws.com/TPT_resources/audio/"
image <- "https://hleetestbuck.s3.eu-central-1.amazonaws.com/TPT_resources/image/"

## Testing options
tpt_admin <- psychTestR::test_options(
  title = 'Timbre Perception Test (TPT)',
  admin_password = "tptonline",
  researcher_email = "hlee@cbs.mpg.de",
  theme = shinytheme("united"),
  logo = "https://s3-eu-west-1.amazonaws.com/media.gold-msi.org/misc/img/logos/longgold_logo_transparent.png",
  logo_width = "200px",
  logo_height = "50px"
)

## Timeline
all_pages <-  psychTestR::join(
  instructions,
  envBlock,
  fluxBlock,
  centBlock,
  score_calculation,
  feedback,
  end,
  psychTestR::final_page('END')
)

make_test(elts = all_pages, opt = tpt_admin)
