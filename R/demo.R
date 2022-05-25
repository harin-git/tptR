#' Demo TPT
#'
#' This function launches a demo for the TPT
#'
#' @param take_training (Boolean scalar) Defines whether instructions and training are included.
#' Defaults to TRUE.
#' @param feedback (Function) Defines the feedback to give the participant
#' at the end of the test. Defaults to a graph-based feedback page.
#' @param admin_password (Scalar character) Password for accessing the admin panel.
#' Defaults to \code{"demo"}.
#' @param researcher_email (Scalar character)
#' If not \code{NULL}, this researcher's email address is displayed
#' at the bottom of the screen so that online participants can ask for help.
#' Defaults to \email{longgold@gold.uc.ak},
#' the email address of this package's developer.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @param language The language you want to run your demo in.
#' Possible languages include English (\code{"en"}) and German (informal \code{"de"}, formal \code{"de_f"}).
#' The first language is selected by default
#' @param ... Further arguments to be passed to \code{\link{TPT}()}.
#' @export

TPT_demo <- function(take_training = TRUE,
                     admin_password = "demo",
                     researcher_email = "longgold@gold.uc.ak",
                     dict = tptR::TPT_dict,
                     language = 'en',
                     feedback = TRUE) {

  demo_pages <- psychTestR::join(
    tptR::instructions(with_volume_headphone_check = TRUE),
    psychTestR::new_timeline(psychTestR::one_button_page(
      shiny::div(
        shiny::tags$h3(psychTestR::i18n("DEMO_HEADER")),
        shiny::hr(),
        shiny::p(psychTestR::i18n("DEMO_INSTRUCTIONS_ITEM1")),
        shiny::p(psychTestR::i18n("DEMO_INSTRUCTIONS_ITEM2")),
        shiny::br(),
      ),
      button_text = psychTestR::i18n("BEGIN_DEMO_BUTTON")),
      dict = dict),
    centBlock(dict = dict),
    psychTestR::new_timeline(
      psychTestR::one_button_page(shiny::div(
        psychTestR::i18n("FEEDBACK_ITEM1"),
        psychTestR::i18n("FEEDBACK_ITEM2"),
        shiny::p(feed_plot(80))
      ))
    , dict = dict),
    psychTestR::new_timeline(
      psychTestR::final_page(psychTestR::i18n("FINISHED"))
    , dict = dict)
  )

  psychTestR::make_test(
    elts = demo_pages,
    opt =  psychTestR::test_options(
      title = "TPT demo",
      admin_password,
      researcher_email,
      demo = TRUE,
      languages = language)
  )
}
