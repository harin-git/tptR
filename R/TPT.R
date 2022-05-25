#' #' TPT module
#'
#' This function contains a TPT psychTestR-module for inlcusion into batter
#' @param label (Scalar character) Label for saving data
#' @param with_welcome (Scalar boolean) Indicates if welcome page will be shown  at beginning of the test module.
#' Defaults to TRUE
#' @param with_feedback (Scalar boolean) Indicates if performance feedback will be given at the end of the test.
#' Defaults to TRUE
#' @param with_training (Boolean scalar) Defines whether instructions and training are included.
#' Defaults to TRUE.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @param ... Further arguments to be passed to \code{\link{TPT}()}.
#' @export
#'
TPT <- function(label = "TPT",
                with_welcome = TRUE,
                with_training = TRUE,
                with_feedback = TRUE,
                dict = tptR::TPT_dict,
                ...) {


  psychTestR::join(
    if(with_welcome) instructions(with_volume_headphone_check = FALSE, dict = dict),
    envBlock(with_training = with_training, dict = dict),
    fluxBlock(with_training = with_training, dict = dict),
    centBlock(with_training = with_training, dict = dict),
    score_calculation,
    if(with_feedback) feedback(dict = dict),
    psychTestR::elt_save_results_to_disk(complete = TRUE)
  )

}

