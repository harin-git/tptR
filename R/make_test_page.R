#' Make real testing trials
#'
#' @param trialName trial items to be sourced. Eg, env1, env2, ... env6
#' @param blockName block name to be displayed to participant. Eg, Block1
#' @param dict The psychTestR dictionary used for internationalisation.
#' @export
makeTestPage <- function(trialName,
                         blockName,
                         dict = tptR::TPT_dict){
  psychTestR::new_timeline(
    psychTestR::page(
      ui =
        shiny::tags$div(
          shiny::tags$div(
            shiny::tags$head(button_style),
            shiny::tags$script(sliderJS(trialName)),
            shiny::tags$strong(blockName),
            shiny::tags$br(),
            shiny::tags$audio(
              id = 'targetAudio',
              src = paste0(audio, trialName, '.mp3'),
              type = 'audio/wav'),
            shiny::tags$br(),
            shiny::tags$button(
              onclick = "playTargetAudio(this)",
              type = 'button',
              psychTestR::i18n("TARGET_SOUND"),
              class = 'button button1'),
            shiny::tags$button(
              id = 'yourSound',
              type = 'button',
              psychTestR::i18n("YOUR_SOUND"),
              class = 'button button2')
          ),
          shiny::tags$br(),
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
          shiny::hr(),
          psychTestR::trigger_button("next", psychTestR::i18n("SUBMIT")),
        ),
      get_answer = function(input, ...)
        as.numeric(input$slider),
      save_answer = TRUE,
      label = paste0("raw_", trialName),
      on_complete = function(answer, state, ...) {
        psychTestR::set_local(trialName, as.numeric(answer), state)
      }
    )
  , dict = dict)
}
