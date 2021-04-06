#' TPT_standalone
#'
#' Run TPT as a standalone (i.e. run locally without hosting on a server).
#' Running this locally will create a local directory folder called 'output' and
#' store participant's response there.
#'
#' @param password Create a password for logging in as an admin.
#' @param your_email The researcher's email to be displayed. Replace with your email address.
#' @export
TPT_standalone <- function(password, your_email = "hlee@cbs.mpg.de"){
  all_pages <- psychTestR::join(
    instructions,
    envBlock,
    fluxBlock,
    centBlock,
    score_calculation,
    feedback,
    psychTestR::elt_save_results_to_disk(complete = TRUE),
    psychTestR::final_page('Thanks for your participation!')
  )

  psychTestR::make_test(elts = all_pages,
                        opt = tpt_admin(password, your_email, demo_ver = FALSE))
}

