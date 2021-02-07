#' makeTestPage
#'
#' This function makes the testing trials.
#'
#' @param blockName The name of the block e.g. "Block 1"
#' @param trialName The trial name must match the audio file name
#' e.g. if trialName <- "env1" the audio file to call should be "~path/env1.mp3"
#'
#' @export makeTestPage


makeTestPage <- function(trialName, blockName){
  psychTestR::page(ui =
         tags$div(
           tags$head(target_button_style),
           tags$div(
             tags$strong(blockName),
             tags$br(),
             tags$audio(id = 'targetAudio',src = paste0(audio, trialName, '.mp3'), type = 'audio/wav'),
             tags$br(),
             tags$button(onclick="document.getElementById('targetAudio').play()",
                         type = 'button',
                         'Target Sound',
                         class = "button"),
             tags$script(HTML("
               var target = document.getElementById('targetAudio')
               document.addEventListener('keydown', function(e){if(e.which == 84){target.play()}})
               ")),
           ),
           tags$br(),
           tags$div(
             class = "slider-container",
             tags$input(type = "range", min = "0", max = "100", value = "50", class="slider", id = "slider")
           ),
           hr(),
           trigger_button("next", "Submit"),
           tags$script(sliderJS(trialName)),
         ),
       get_answer = function(input, ...) as.numeric(input$slider),
       save_answer = TRUE,
       label = trialName,
       on_complete = function(answer, state, ...) {
         set_local(trialName, as.numeric(answer), state)
       }
  )
}
