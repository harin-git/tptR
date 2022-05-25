#' #' Standalone TPT
#'
#' This function launches a standalone testing session for the TPT
#' This can be used for data collection, either in the laboratory or online.
#' @param title (Scalar character) Title to display during testing.
#' @param with_feedback (Scalar boolean) Indicates if performance feedback will be given at the end of the test.
#' Defaults to TRUE
#' @param with_training (Boolean scalar) Defines whether instructions and training are included.
#' Defaults to TRUE.
#' @param with_welcome (Boolean scalar) Defines whether welcome page will be shown at beginning of the test.
#' Defaults to TRUE.
#' @param admin_password (Scalar character) Password for accessing the admin panel.
#' @param researcher_email (Scalar character)
#' If not \code{NULL}, this researcher's email address is displayed
#' at the bottom of the screen so that online participants can ask for help.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include English (\code{"en"}),
#' German (informal: \code{"de"} and formal \code{"de_f"}), and Italian (\code{"it"})
#' The first language is selected by default
#' @param dict The psychTestR dictionary used for internationalisation.
#' @param with_id participant ID. Default to FALSE
#' @param validate_id (Character scalar or closure) Function for validating IDs or string "auto" for default validation
#' which means ID should consist only of  alphanumeric characters.
#' @param ... Further arguments to be passed to \code{\link{TPT}()}.
#' @export
#'
TPT_standalone <- function(title = NULL,
                           with_feedback = TRUE,
                           with_training = TRUE,
                           with_welcome = TRUE,
                           admin_password = "conifer",
                           researcher_email = "longgold@gold.uc.ak",
                           languages = c("en", "de", "de_f"),
                           dict = tptR::TPT_dict,
                           with_id = FALSE,
                           validate_id = "auto",
                           ...) {

  elt <- psychTestR::join(
    if(with_id) psychTestR::new_timeline(
      psychTestR::get_p_id(prompt = psychTestR::i18n("ENTER_ID"),
                           button_text = psychTestR::i18n("CONTINUE"),
                           validate = validate_id),
      dict = dict
    ),
    TPT(with_welcome = with_welcome, with_training = with_training, with_feedback = with_feedback),
    psychTestR::new_timeline(
      psychTestR::final_page(shiny::p(
        psychTestR::i18n("RESULTS_SAVED"),
        psychTestR::i18n("CLOSE_BROWSER"))
      ), dict = dict)
  )
  if(is.null(title)){
    title <-
      unlist(stats::setNames(
        purrr::map(tptR::TPT_languages(), function(x)
          tptR::TPT_dict$translate("TESTNAME", x)),
        tptR::TPT_languages()
      ))
  }
  psychTestR::make_test(elts = elt,
                        opt = psychTestR::test_options(title = title,
                                                       admin_password = admin_password,
                                                       researcher_email = researcher_email,
                                                       demo = FALSE,
                                                       languages = tolower(languages)))
}

