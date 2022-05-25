#' Makes demo practice trials
#'
#' This assigns where the target value (i.e. correct slider position) should be in a given
#' practice trial.
#'
#' @param blockName name of the block to be displayed e.g. Block1
#' @param trialName name of audio file prefix. If file is called 'env_13.mp3', 'env' is the trialName
#' @param targetValue the value of sampled slider position. If file is called 'env_13.mp3', '13' is the targetValue
#' @param dict The psychTestR dictionary used for internationalisation.
#' @export
makeDemoPage <- function(blockName,
                         trialName,
                         targetValue,
                         dict = tptR::TPT_dict){
  # page displaying practice trial
  demo_page <-
    psychTestR::new_timeline(
      psychTestR::page(
        ui =
          shiny::tags$div(
            shiny::tags$head(button_style),
            shiny::tags$script(sliderJS(trialName)),
            shiny::tags$div(
              shiny::tags$strong(sprintf("Practice Trial - %s", blockName)),
              shiny::br(),
              shiny::tags$audio(
                id = 'targetAudio',
                src = paste0(audio, trialName, '_', targetValue, '.mp3'),
                type = "audio/wav"
              ),
              shiny::br(),
              shiny::tags$button(
                onclick = "playTargetAudio(this)",
                type = 'button',
                psychTestR::i18n("TARGET_SOUND"),
                class = 'button button1'
              ),
              shiny::tags$button(
                id = 'yourSound',
                type = 'button',
                psychTestR::i18n("YOUR_SOUND"),
                class = 'button button2'
              )
            ),
            shiny::br(),
            shiny::tags$div(
              class = "slider-container",
              shiny::tags$input(
                type = "range",
                min = "0",
                max = "100",
                value = "50",
                class = "slider",
                id = "slider"
              )
            ),
            shiny::p(psychTestR::i18n("DEMO_PLAY_SLIDER")),
            psychTestR::trigger_button("next", psychTestR::i18n("SEE_CORRECT")),
          ),
        validate = function(input, ...) {
          answer <- as.numeric(input$slider)
          if (answer > (targetValue - 30) &&
              answer < (targetValue + 30))
            TRUE
          else
            psychTestR::i18n("ALMOST_THERE")
        },
        get_answer = function(input, ...)
          as.numeric(input$slider),
        save_answer = FALSE,
        label = trialName
      )
    , dict = dict)

  # page displaying feedback about correct slider position and participant's position
  demo_feedback <- psychTestR::new_timeline(
      psychTestR::reactive_page(function(answer, ...) {
        whichSide <- ifelse(answer > targetValue,
                            psychTestR::i18n("LEFT"),
                            psychTestR::i18n("RIGHT"))
        psychTestR::NAFC_page(
          label = 'demo_feedback',
          shiny::div(
            shiny::tags$strong(psychTestR::i18n("SLIDER_POSITION")),
            shiny::tags$input(
              type = 'range',
              min = '0',
              max = '100',
              value = answer,
              disabled = TRUE
            ),
            shiny::p(psychTestR::i18n("YOUR_SLIDER")),
            shiny::hr(),
            shiny::tags$strong(psychTestR::i18n("CORRECT_SLIDER_POSITION")),
            shiny::tags$input(
              type = 'range',
              min = '0',
              max = '100',
              value = targetValue,
              disabled = TRUE
            ),
            shiny::p(
              psychTestR::i18n("CORRECT_POSITION_LONG", sub = c(side = whichSide)),
            ),
            shiny::br()
          ),
          save_answer = FALSE,
          choices = c('real', 'again'),
          labels = c(psychTestR::i18n("BEGIN_REAL_TEST"), psychTestR::i18n("PRACTICE_AGAIN")),
          on_complete = function(state, answer, ...) {
            psychTestR::set_local("do_practice", identical(answer, "again"), state)
          }
        )
      })
    , dict = dict)

  # join and return
  psychTestR::join(demo_page, demo_feedback)
}
