#' TPT_test
#'
#' Run TPT as a standalone (i.e. run locally without hosting on a server).
#' Running this locally will create a local directory called 'output' and
#' store participant's response there.
#'
#' @param password Create a password to login as an admin
#' @param researcher_email The researcher's email to be displayed. Default set to the
#' developer's email
#' @export
#' @examples
#' TPT_test(password = "test1234", researcher_email = "hlee@cbs.mpg.de")

TPT_test <- function(password, researcher_email = "hlee@cbs.mpg.de"){
  psychTestR::make_test(elts = all_pages,
                        opt = tpt_admin(password = password, researcher_email = researcher_email))
}

## Initialize----
audio <- "https://hleetestbuck.s3.eu-central-1.amazonaws.com/TPT_resources/audio/"
image <- "https://hleetestbuck.s3.eu-central-1.amazonaws.com/TPT_resources/image/"

target_button_style <- shiny::tags$style(
  ".button {
    display: inline-block;
    padding: 15px 25px;
    font-size: 20px;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    outline: none;
    color: #fff;
    background-color: #ffa500;
    border: none;
    border-radius: 15px;
    box-shadow: 0 9px #999;
  }

  .button:hover {
  	background-color: #ffd280;
  }

  @keyframes glowing {
    0% {
      background-color: #ffa500;
      box-shadow: 0 0 5px #ffa500;
    }
    16% {
      background-color: #ffd280;
      box-shadow: 0 0 20px #ffa500;
    }
    32% {
      background-color: #ffa500;
      box-shadow: 0 0 5px #ffa500;
    }
    48% {
      background-color: #ffa500;
      box-shadow: 0 0 5px #ffa500;
    }
    64% {
      background-color: #ffd280;
      box-shadow: 0 0 20px #ffa500;
    }
    80% {
      background-color: #ffa500;
      box-shadow: 0 0 5px #ffa500;
    }
  }

  .button:active {
    box-shadow: 0 5px #666;
    transform: translateY(4px);
    animation: glowing 2400ms;
  }
  "
)

sliderJS <- function(trialName){
  shiny::HTML(sprintf("var audio = new Audio();
    var slider = document.getElementById('slider');

    function export_answer(value) {
      Shiny.onInputChange('slider', value);
    }

    function play_audio() {
      console.log('hi');
      var value = slider.value;
      export_answer(value);
      var url = '%s' + '_' + value + '.mp3';
      audio.pause();
      audio = new Audio(url);
      audio.play();
    }

    export_answer(slider.value);
    slider.addEventListener('change', play_audio)
    ",
                      paste0(audio, trialName)
  ))
}


## Functions----
makeDemoPage <- function(blockName, trialName, targetValue){
  psychTestR::join(
    psychTestR::page(ui =
                       shiny::tags$div(
                         shiny::tags$head(target_button_style),
                         shiny::tags$script(sliderJS(trialName)),
                         shiny::tags$div(
                           shiny::tags$strong(sprintf("Practice Trial - %s", blockName)),
                           shiny::br(),
                           shiny::tags$audio(id = 'demoAudio', src = paste0(audio,'demo_', trialName, '.mp3'), type = "audio/wav"),
                           shiny::br(),
                           shiny::tags$button(
                             onclick="document.getElementById('demoAudio').play()",
                             type = 'button',
                             'Target Sound',
                             class='button'
                           )
                         ),
                         shiny::br(),
                         shiny::tags$div(class = "slider-container", shiny::tags$input(type = "range", min = "0", max = "100", value = "50", class="slider", id = "slider")),
                         shiny::p("Play around with the slider to hear how the sound changes"),
                         psychTestR::trigger_button("next", "See correct answer"),
                       ),
                     validate = function(input, ...){
                       answer <- as.numeric(input$slider)
                       if (answer > (targetValue - 15) && answer < (targetValue + 15)) TRUE else "Try again, you're almost there!"
                     },
                     get_answer = function(input, ...) as.numeric(input$slider),
                     save_answer = FALSE,
                     label = trialName
    ),
    psychTestR::reactive_page(function(answer, ...) {
      whichSide <- if(answer > targetValue){"left"} else {"right"}

      psychTestR::one_button_page(
        shiny::div(
          shiny::tags$strong('[ Your slider position ]'),
          shiny::tags$input(type = 'range', min = '0', max = '100', value = answer, disabled = TRUE),
          shiny::p('This is where you placed the slider.'),
          shiny::hr(),
          shiny::tags$strong('[ Correct slider position ]'),
          shiny::tags$input(type = 'range', min = '0', max = '100', value = targetValue, disabled = TRUE),
          shiny::p("The correct position would've been slightly more to the ", shiny::tags$strong(whichSide)),
          shiny::br()
        ),
        button_text = "Begin the real test!"
      )
    })
  )
}

makeTestPage <- function(trialName, blockName){
  psychTestR::page(ui =
                     shiny::tags$div(
                       shiny::tags$head(target_button_style),
                       shiny::tags$div(
                         shiny::tags$strong(blockName),
                         shiny::tags$br(),
                         shiny::tags$audio(id = 'targetAudio',src = paste0(audio, trialName, '.mp3'), type = 'audio/wav'),
                         shiny::tags$br(),
                         shiny::tags$button(onclick="document.getElementById('targetAudio').play()",
                                            type = 'button',
                                            'Target Sound',
                                            class = "button"),
                         shiny::tags$script(shiny::HTML("
               var target = document.getElementById('targetAudio')
               document.addEventListener('keydown', function(e){if(e.which == 84){target.play()}})
               ")),
                       ),
                       shiny::tags$br(),
                       shiny::tags$div(
                         class = "slider-container",
                         shiny::tags$input(type = "range", min = "0", max = "100", value = "50", class="slider", id = "slider")
                       ),
                       shiny::hr(),
                       psychTestR::trigger_button("next", "Submit"),
                       shiny::tags$script(sliderJS(trialName)),
                     ),
                   get_answer = function(input, ...) as.numeric(input$slider),
                   save_answer = TRUE,
                   label = trialName,
                   on_complete = function(answer, state, ...) {
                     set_local(trialName, as.numeric(answer), state)
                   }
  )
}

## Instructions----
landing <- psychTestR::one_button_page(
  shiny::div(
    shiny::tags$h3("Do you have good ears for discriminating sounds?"),
    shiny::hr(),
    shiny::p("This test examines your ability to match one sound to another."),
    shiny::p("Take the test and receive a score at the end!")
  ),
  button_text = "Begin Test"
)

volumeCheck <- psychTestR::one_button_page(
  shiny::div(
    shiny::tags$h3("Volume Check"),
    shiny::hr(),
    shiny::p("Let's first make sure that you are comfortable with volume."),
    shiny::br(),
    shiny::tags$audio(src = paste0(audio,"volume_check.mp3"), type = "audio/mp3", autoplay = TRUE, controls = FALSE),
    shiny::p("Adjust your volume"),
    shiny::br(),
    shiny::tags$strong("*We highly recommend that you use headphones to take this test"),
    shiny::hr()
  ),
  button_text = "Volume is Good"
)

playback <- psychTestR::NAFC_page(
  "playback_device",
  "Which device are you using to play the sound?",
  c("Stereo Speakers", "Headphones", "Laptop Speakers", "Phone")
)

instruct1 <- psychTestR::one_button_page(shiny::div(
  shiny::tags$h3("Instructions"),
  shiny::hr(),
  shiny::tags$li("When you begin the test, you will hear a", shiny::tags$strong("taget sound")),
  shiny::tags$li("You can play the target sound anytime by clicking it"),
  shiny::tags$li("The slider bar below allows you to produce", shiny::tags$strong("your own sound")),
  shiny::tags$li("Your own sound will change as you move the slider"),
  shiny::tags$li("Your task is to match", shiny::tags$strong("your sound"), "to the", shiny::tags$strong("target sound"),"as close as possible"),
  shiny::br(),
  shiny::tags$img(src = paste0(image, "instruction1.png"), height = 110, width = 600),
), button_text = "I Get It"
)

instruct2 <- psychTestR::one_button_page(shiny::div(
  shiny::tags$h3("Instructions"),
  shiny::hr(),
  shiny::tags$li("The test is divided into 3 Blocks with 6 trials per Block"),
  shiny::tags$li("Moving the slider will change the sound differently in each Block"),
  shiny::tags$li("There will be a practice trial before each Block for you to become familiar with what the slider does"),
  shiny::br(),
  shiny::tags$img(src = paste0(image,"instruction2.png"), height = 120, width = 450),
  shiny::hr(),
  shiny::p("If you find any of this confusing, don't worry we got you covered."),
  shiny::p("In the next page, you'll have the chance to play around with the controls."),
), button_text = "Begin Practice Trial"
)

instructions <- psychTestR::join(landing, volumeCheck, playback, instruct1, instruct2)

## Testing Blocks----
page_after_block <- purrr::map(c(
  "Well done. You completed the first Block. Let's move on to the second one!",
  "You completed the second Block. One more to go!",
  "Fantastic! You now completed all the Blocks. Before we finish, we'll ask you few questions about your background."
),
psychTestR::one_button_page
)

envDemo <- makeDemoPage("Block 1", "env1", 15)
envItems <- purrr::map2(.x = paste0("env", 1:6), .y = "[ Block 1 ]", .f = makeTestPage)
envBlock <- psychTestR::join(envDemo,
                             psychTestR::randomise_at_run_time("env_order", logic =  envItems),
                             page_after_block[1])

fluxDemo <- makeDemoPage("Block 2", "flux1", 75)
fluxItems <- purrr::map2(.x = paste0("flux", 1:6), .y = "[ Block 2 ]", .f = makeTestPage)
fluxBlock <- psychTestR::join(fluxDemo,
                              psychTestR::randomise_at_run_time("flux_order", logic =  fluxItems),
                              page_after_block[2])

centDemo <- makeDemoPage("Block 3", "cent1", 88)
centItems <- purrr::map2(.x = paste0("cent", 1:6), .y = "[ Block 3 ]", .f = makeTestPage)
centBlock <- psychTestR::join(centDemo,
                              psychTestR::randomise_at_run_time("cent_order", logic =  centItems),
                              page_after_block[3])


## Ending----
participant <- psychTestR::get_p_id(shiny::div(
  shiny::p("Please enter your participant ID"),
  shiny::p("*If you're a MTurk participant, enter your WorkerID")),
)

sendCode <- psychTestR::finish_test_and_give_code("hlee@cbs.mpg.de")
end <-  psychTestR::join(participant, sendCode)


## Feedback ----
TPT_original <- read.csv("tpt_data/TPT_rawDistance.csv")[ ,2:14]
TPT_original_mean <- rowMeans(TPT_original)
TPT_quantile <- quantile(TPT_original_mean, probs = seq(0,1, 0.01))
TPT_percentile <- ecdf(TPT_original_mean)

score_calculation <-  psychTestR::code_block(function(state, ...) {
  trial_names <- c(paste0("env", 1:6), paste0("flux", 1:6), paste0("cent", 1:6))
  new_target_values <- c(78, 22, 6, 62, 38, 94, 38, 62, 94, 78, 22, 6, 22, 78, 38, 6, 94, 62)

  response <- purrr::map_dbl(trial_names, get_local, state)

  participant_distance_score <- abs(response - new_target_values)
  participants_distance_mean <- signif(mean(participant_distance_score), digits = 2)
  feedback_score <- signif(100 - participants_distance_mean/50*100, digits = 2)
  abs_distance_quantile <- signif(TPT_percentile(participants_distance_mean)*100, digits = 2)

  psychTestR::set_local("feedback_score", feedback_score, state)
  psychTestR::set_local("abs_distance_quantile", abs_distance_quantile, state)
})

feedback <- psychTestR::new_timeline(
  psychTestR::reactive_page(function(state, ...) {
    psychTestR::one_button_page(div(
      p("Your score was:", strong(psychTestR::get_local("feedback_score", state)), " (out of 100)"),
      p("This places you in the top ", strong(psychTestR::get_local("abs_distance_quantile", state)),
        "% percentile of everyone who took this test."),
      p("Well done!")
    ))
  }
  ))

## Timeline----
all_pages <-  psychTestR::join(
  instructions,
  envBlock,
  fluxBlock,
  centBlock,
  score_calculation,
  feedback,
  end,
  psychTestR::final_page('END')
)

## Testing options----
tpt_admin <- function(password, researcher_email){
  psychTestR::test_options(
  title = 'Timbre Perception Test (TPT)',
  admin_password = password,
  researcher_email = researcher_email,
  theme = shinythemes::shinytheme("united"),
  logo = "https://s3-eu-west-1.amazonaws.com/media.gold-msi.org/misc/img/logos/longgold_logo_transparent.png",
  logo_width = "200px",
  logo_height = "50px")}
