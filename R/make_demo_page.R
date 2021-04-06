#' Makes demo practice trials
#'
#' This assigns where the target value (i.e. correct slider position) should be in a given
#' practice trial.
#'
#' @param blockName name of the block to be displayed e.g. Block1
#' @param trialName name of audio file prefix. If file is called 'env_13.mp3', 'env' is the trialName
#' @param targetValue the value of sampled slider position. If file is called 'env_13.mp3', '13' is the targetValue
makeDemoPage <- function(blockName, trialName, targetValue){
  # page displaying practice trial
  demo_page <- psychTestR::page(
    ui =
      shiny::tags$div(
        shiny::tags$head(button_style),
        shiny::tags$script(sliderJS(trialName)),
        shiny::tags$div(
          shiny::tags$strong(sprintf("Practice Trial - %s", blockName)),
          shiny::br(),
          shiny::tags$audio(
            id = 'targetAudio',
            src = paste0(audio, trialName, '_', targetValue,'.mp3'),
            type = "audio/wav"
          ),
          shiny::br(),
          shiny::tags$button(
            onclick = "playTargetAudio(this)",
            type = 'button',
            'Target Sound',
            class = 'button button1'),
          shiny::tags$button(
            id = 'yourSound',
            type = 'button',
            'Your Sound',
            class = 'button button2')
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
        shiny::p("Play around with the slider to hear how the sound changes"),
        psychTestR::trigger_button("next", "See correct answer"),
      ),
    validate = function(input, ...) {
      answer <- as.numeric(input$slider)
      if (answer > (targetValue - 30) &&
          answer < (targetValue + 30))
        TRUE
      else
        "Try again, you're almost there!"
    },
    get_answer = function(input, ...)
      as.numeric(input$slider),
    save_answer = FALSE,
    label = trialName
  )

  # page displaying feedback about correct slider position and participant's position
  demo_feedback <- psychTestR::reactive_page(function(answer, ...) {
    whichSide <- ifelse(answer > targetValue, 'left', 'right')
    psychTestR::NAFC_page(
      label = 'demo_feedback',
      shiny::div(
        shiny::tags$strong('[ Your slider position ]'),
        shiny::tags$input(
          type = 'range',
          min = '0',
          max = '100',
          value = answer,
          disabled = TRUE
        ),
        shiny::p('This is where you placed the slider.'),
        shiny::hr(),
        shiny::tags$strong('[ Correct slider position ]'),
        shiny::tags$input(
          type = 'range',
          min = '0',
          max = '100',
          value = targetValue,
          disabled = TRUE
        ),
        shiny::p(
          "The correct position would've been slightly more to the ",
          shiny::tags$strong(whichSide)
        ),
        shiny::br()
      ),
      save_answer = FALSE,
      choices = c('real', 'again'),
      labels = c('Begin the Real Test', 'Practice Again'),
      on_complete = function(state, answer, ...) {
        psychTestR::set_local("do_practice", identical(answer, "again"), state)
      }
    )
  })
  psychTestR::join(demo_page, demo_feedback)
}
