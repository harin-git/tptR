#' makeDemoPage
#'
#' This function makes the demo trials, which is displayed prior to starting
#' the real test for each Block.
#'
#' @param blockName The name of the block e.g. "Block 1"
#' @param trialName The trial name must match the audio file name
#' e.g. if trialName <- "env1" the audio file to call should be "~path/env1.mp3"
#' @param targetValue The answer position of the slider that the participant must
#' get close to. When participant's position false outside the acceptable range
#' (default = +- 15), there will be a pop-up telling you to try again.
#'
#' @export makeDemoPage

makeDemoPage <- function(blockName, trialName, targetValue){
  join(
    page(ui =
           tags$div(
             tags$head(target_button_style),
             tags$div(
               tags$strong(sprintf("Practice Trial - %s", blockName)),
               br(),
               tags$audio(id = 'demoAudio',src = paste0(audio,'demo_', trialName, '.mp3'), type = "audio/wav"),
               br(),
               tags$button(
                 onclick="document.getElementById('demoAudio').play()",
                 type = 'button',
                 'Target Sound',
                 class='button'
               )
             ),
             br(),
             tags$div(class = "slider-container", tags$input(type = "range", min = "0", max = "100", value = "50", class="slider", id = "slider")),
             p("Play around with the slider to hear how the sound changes"),
             trigger_button("next", "See correct answer"),
             tags$script(sliderJS(trialName))
           ),
         validate = function(input, ...){
           answer <- as.numeric(input$slider)
           if (answer > (targetValue - 15) && answer < (targetValue + 15)) TRUE else "Try again, you're almost there!"
         },
         get_answer = function(input, ...) as.numeric(input$slider),
         save_answer = FALSE,
         label = trialName
    ),
    reactive_page(function(answer, ...) {
      whichSide <- if(answer > targetValue){"left"} else {"right"}

      one_button_page(
        div(
          tags$strong('[ Your slider position ]'),
          tags$input(type = 'range', min = '0', max = '100', value = answer, disabled = TRUE),
          p('This is where you placed the slider.'),
          hr(),
          tags$strong('[ Correct slider position ]'),
          tags$input(type = 'range', min = '0', max = '100', value = targetValue, disabled = TRUE),
          p("The correct position would've been slightly more to the ", tags$strong(whichSide)),
          br()
        ),
        button_text = "Begin the real test!"
      )
    })
  )
}
