#' Instructions & AWS S3 directory
#'
#' @param with_volume_headphone_check page asking to calibrate volume and
#' a question about audio output device. Default is \code{FALSE}
#' @param dict The psychTestR dictionary used for internationalisation.
instructions <- function(with_volume_headphone_check = FALSE,
                         dict = tptR::TPT_dict){

  landing <- psychTestR::new_timeline(psychTestR::one_button_page(
    shiny::div(
      shiny::tags$h3(psychTestR::i18n("TESTNAME")),
      shiny::tags$hr(),
      psychTestR::i18n("WELCOME"),
      shiny::br(),
      psychTestR::i18n("INTRO"),
    ),
    button_text = psychTestR::i18n("BEGIN_TEST")
  ),
  dict = dict)

  volumeCheck <-  psychTestR::new_timeline(psychTestR::one_button_page(
    shiny::div(
      shiny::tags$h3(psychTestR::i18n("VOLUME_CHECK_HEADER")),
      shiny::hr(),
      shiny::p(psychTestR::i18n("VOLUME_CHECK_INSTRUCTIONS")),
      shiny::br(),
      shiny::tags$audio(
        src = paste0(audio, "volume_check.mp3"),
        type = "audio/mp3",
        autoplay = TRUE,
        controls = FALSE
      ),
      shiny::p(psychTestR::i18n("VOLUME_ADJUST")),
      shiny::br(),
      shiny::p(psychTestR::i18n("RECOMMEND_HEADPHONE")),
      shiny::hr()
    ),
    button_text = psychTestR::i18n("VOLUME_GOOD")
  ),
  dict = dict)

  playback <- psychTestR::new_timeline(
    psychTestR::NAFC_page(
      "playback_device",
      psychTestR::i18n("WHICH_DEVICE"),
      c(psychTestR::i18n("STEREO_SPEAKERS"),
        psychTestR::i18n("HEADPHONES"),
        psychTestR::i18n("LAPTOP_SPEAKERS"),
        psychTestR::i18n("PHONE"))
    ),
    dict = dict
  )

  instruct1 <- psychTestR::new_timeline(psychTestR::one_button_page(
    shiny::div(
      shiny::tags$h3(psychTestR::i18n("INSTRUCTIONS")),
      shiny::hr(),
      shiny::tags$li(psychTestR::i18n("INSTRUCTIONS_ITEM1")),
      shiny::tags$li(psychTestR::i18n("INSTRUCTIONS_ITEM2")),
      shiny::tags$li(psychTestR::i18n("INSTRUCTIONS_ITEM3")),
      shiny::tags$li(psychTestR::i18n("INSTRUCTIONS_ITEM4")),
      shiny::br(),
      shiny::tags$img(
        src = paste0(image, "instruction1.png"),
        height = 110,
        width = 600
      ),
    ),
    button_text = psychTestR::i18n("I_GET_IT")
  ),
  dict = dict)

  instruct2 <- psychTestR::new_timeline(
    psychTestR::one_button_page(
      shiny::div(
        shiny::tags$h3(psychTestR::i18n("INSTRUCTIONS")),
        shiny::hr(),
        shiny::tags$li(psychTestR::i18n("INSTRUCTIONS2_ITEM1")),
        shiny::tags$li(psychTestR::i18n("INSTRUCTIONS2_ITEM2")),
        shiny::tags$li(psychTestR::i18n("INSTRUCTIONS2_ITEM3")),

        shiny::br(),
        shiny::tags$img(
          src = paste0(image, "instruction2.png"),
          height = 120,
          width = 450
        ),
        shiny::hr(),
        shiny::p(psychTestR::i18n("INSTRUCTIONS2_ITEM4")),
        shiny::p(psychTestR::i18n("INSTRUCTIONS2_ITEM5"))
      ),
      button_text = psychTestR::i18n("BEGIN_PRACTICE")
    ),
    dict = dict
  )

  # return a joined timeline
  with_volume_heaphone_instruction <- psychTestR::join(
    landing, volumeCheck, playback, instruct1, instruct2)

  without_volume_heaphone_instruction <- psychTestR::join(
    landing, instruct1, instruct2)

  if(with_volume_headphone_check == TRUE){
    return(with_volume_heaphone_instruction)
  } else {
    return(without_volume_heaphone_instruction)
  }
}

