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
TPT_test <- function(password, researcher_email = "hlee@cbs.mpg.de"){
  psychTestR::make_test(elts = all_pages,
                        opt = tpt_admin(password, researcher_email = researcher_email))
}

## Initialize----
# AWS S3 buckets where audio and images are stored
audio <- "https://hleetestbuck.s3.eu-central-1.amazonaws.com/TPT_resources/audio/"
image <- "https://hleetestbuck.s3.eu-central-1.amazonaws.com/TPT_resources/image/"

#This is the CSS styler for the 'target sound' button
button_style <- shiny::tags$style(
  ".button {
    display: inline-block;
    padding: 15px 25px;
    font-size: 16px;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    outline: none;
    color: black;
    background-color: #white;
    border: 2px solid #B2B2B2;
    border-radius: 15px;
    box-shadow: 0 9px #999;
    width: 180px;
    margin: 4px 10px;
  }

  .button:hover {
    background-color: #ffa500;
    color: white;
    border: 2px solid #ffa500;
  }

  .active {
    position: relative;
    animation: glowing 2000ms 1;
  }

  @keyframes glowing {
    0% {
      background-color: #ffa500;
      box-shadow: 0 5px ##999;
      border: 2px solid #ffa500;
      color: white;
    }
    80% {
      background-color: #ffa500;
      box-shadow: 0 0 30px #ffa500;
      border: 2px solid #ffa500;
      color: white;
      transform: translateY(4px);
    }
  }"
)

# This is the JS script for moveable slider that triggers sound
sliderJS <- function(trialName) {
  shiny::HTML(
    sprintf(
    "var yourAudio = new Audio();
    var slider = document.getElementById('slider');

    function export_answer(value) {
      Shiny.onInputChange('slider', value);
    }

    function playYourAudio() {
      console.log('hi');
      var value = slider.value;
      export_answer(value);
      document.getElementById('targetAudio').pause();
      document.getElementById('targetAudio').currentTime = 0;
      var url = '%s' + '_' + value + '.mp3';
      yourAudio.pause();
      yourAudio = new Audio(url);
      yourAudio.play();
      let elem = document.getElementById('yourSound');
      elem.classList.remove('active');
      elem.classList.add('active');
      setTimeout(function () {
        elem.classList.remove('active');
      }, 2000);
    }

    function playTargetAudio(elem) {
      yourAudio.pause();
      document.getElementById('targetAudio').currentTime = 0;
      document.getElementById('targetAudio').play();
      elem.classList.remove('active');
      elem.classList.add('active');
      setTimeout(function () {
        elem.classList.remove('active');
      }, 2000);
    }

    export_answer(slider.value);
    slider.addEventListener('change', playYourAudio);
    yourSound.addEventListener('click', playYourAudio);
    ", paste0(audio, trialName)
    )
  )
}

## Functions----
makeDemoPage <- function(blockName, trialName, targetValue){
  psychTestR::join(
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
              src = paste0(audio, 'demo_', trialName, '.mp3'),
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
        if (answer > (targetValue - 15) &&
            answer < (targetValue + 15))
          TRUE
        else
          "Try again, you're almost there!"
      },
      get_answer = function(input, ...)
        as.numeric(input$slider),
      save_answer = FALSE,
      label = trialName
    ),
    psychTestR::reactive_page(function(answer, ...) {
      whichSide <- if (answer > targetValue) {
        "left"
      } else {
        "right"
      }

      psychTestR::one_button_page(
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
        button_text = "Begin the real test!"
      )
    })
  )
}
makeTestPage <- function(trialName, blockName){
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
            'Target Sound',
            class = 'button button1'),
          shiny::tags$button(
            id = 'yourSound',
            type = 'button',
            'Your Sound',
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
        psychTestR::trigger_button("next", "Submit"),
      ),
    get_answer = function(input, ...)
      as.numeric(input$slider),
    save_answer = TRUE,
    label = paste0("raw_", trialName),
    on_complete = function(answer, state, ...) {
      psychTestR::set_local(trialName, as.numeric(answer), state)
    }
  )
}

## Instructions----
landing <- psychTestR::one_button_page(shiny::div(
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
    shiny::tags$audio(
      src = paste0(audio, "volume_check.mp3"),
      type = "audio/mp3",
      autoplay = TRUE,
      controls = FALSE
    ),
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

instruct1 <- psychTestR::one_button_page(
  shiny::div(
    shiny::tags$h3("Instructions"),
    shiny::hr(),
    shiny::tags$li("When you begin the test, you will hear a",shiny::tags$strong("taget sound")),
    shiny::tags$li("You can play the target sound anytime by clicking it"),
    shiny::tags$li("The slider bar below allows you to produce", shiny::tags$strong("your own sound")),
    shiny::tags$li("Your own sound will change as you move the slider"),
    shiny::tags$li(
      "Your task is to match",
      shiny::tags$strong("your sound"),
      "to the",
      shiny::tags$strong("target sound"),
      "as close as possible"
    ),
    shiny::br(),
    shiny::tags$img(
      src = paste0(image, "instruction1.png"),
      height = 110,
      width = 600
    ),
  ),
  button_text = "I Get It"
)

instruct2 <- psychTestR::one_button_page(
  shiny::div(
    shiny::tags$h3("Instructions"),
    shiny::hr(),
    shiny::tags$li("The test is divided into 3 Blocks with 6 trials per Block"),
    shiny::tags$li("Moving the slider will change the sound differently in each Block"),
    shiny::tags$li("There will be a practice trial before each Block for you to become familiar with what the slider does"),
    shiny::br(),
    shiny::tags$img(
      src = paste0(image, "instruction2.png"),
      height = 120,
      width = 450
    ),
    shiny::hr(),
    shiny::p("If you find any of this confusing, don't worry we got you covered."),
    shiny::p("In the next page, you'll have the chance to play around with the controls."),
  ),
  button_text = "Begin Practice Trial"
)

instructions <- psychTestR::join(landing, volumeCheck, playback, instruct1, instruct2)

## Testing Blocks----
page_after_block <- purrr::map(
  c(
    "Well done. You completed the first Block. Let's move on to the second one!",
    "You completed the second Block. One more to go!",
    "Fantastic! You now completed all the Blocks."
  ),
  psychTestR::one_button_page
)

envDemo <- makeDemoPage("Block 1", "env1", 15)
envItems <- purrr::map2(.x = paste0("env", 1:6), .y = "[ Block 1 ]", .f = makeTestPage)
envBlock <- psychTestR::join(
  envDemo,
  psychTestR::randomise_at_run_time("env_order", logic =  envItems),
  page_after_block[1]
)

fluxDemo <- makeDemoPage("Block 2", "flux1", 75)
fluxItems <- purrr::map2(.x = paste0("flux", 1:6), .y = "[ Block 2 ]", .f = makeTestPage)
fluxBlock <- psychTestR::join(
  fluxDemo,
  psychTestR::randomise_at_run_time("flux_order", logic =  fluxItems),
  page_after_block[2]
)

centDemo <- makeDemoPage("Block 3", "cent1", 88)
centItems <- purrr::map2(.x = paste0("cent", 1:6), .y = "[ Block 3 ]", .f = makeTestPage)
centBlock <- psychTestR::join(
  centDemo,
  psychTestR::randomise_at_run_time("cent_order", logic =  centItems),
  page_after_block[3]
)


## Ending----
participant <- psychTestR::get_p_id(shiny::div(
  shiny::p("Please enter your participant ID"),
  shiny::p("*If you're a MTurk participant, enter your WorkerID")
  )
)

sendCode <- psychTestR::finish_test_and_give_code("hlee@cbs.mpg.de")
end <-  psychTestR::join(participant, sendCode)


## Feedback ----
# This function transforms raw participant score to bin scores
bin_transform <- function(participant_abs_dist, target_value){
  max.dist <- NULL
  for(i in 1:length(participant_abs_dist)){
    if(target_value[i]<50){
      max.dist[i] <- 101 - target_value[i]
      participant_abs_dist[i] <- log((participant_abs_dist[i]+1) / max.dist[i] ) %/% (log(max.dist)/5)
    }
    else{
      max.dist[i] <- 1 + target_value[i]
      participant_abs_dist[i] <- log((participant_abs_dist[i]+1) / max.dist[i] ) %/% (log(max.dist)/5)
    }
  }
  abs(participant_abs_dist)
}

# Function to make curve graph
feed_plot <- function(score){
  q <- ggplot2::ggplot(data.frame(x = c(0, 100)), ggplot2::aes(x)) +
    ggplot2::stat_function(fun = dnorm, args = list(mean = 50, sd = 20)) +
    ggplot2::stat_function(
      fun = dnorm,
      args = list(mean = 50, sd = 20),
      xlim = c(score, 100),
      fill = "lightblue4",
      geom = "area") +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank()) +
    ggplot2::labs(x = "Score (out of 100)", y = "")
  plotly::ggplotly(q, width = 600, height = 450)
}

score_calculation <-  psychTestR::code_block(function(state, ...) {
  trial_names <- c(paste0("env", 1:6), paste0("flux", 1:6), paste0("cent", 1:6))
  new_target_values <- c(78, 22, 6, 62, 38, 94, 38, 62, 94, 78, 22, 6, 22, 78, 38, 6, 94, 62)

  response <- purrr::map_dbl(trial_names, psychTestR::get_local, state)

  participant_distance_score <- abs(response - new_target_values)

  bin_transformed <- bin_transform(
    participant_distance_score,
    new_target_values
  ) # transforms participants response to bin scores of 0 ~ 5

  # calculate mean bin scores
  env_mean <- mean(bin_transformed[1:6])
  flux_mean <- mean(bin_transformed[7:12])
  cent_mean <- mean(bin_transformed[13:18])
  general_mean <- mean(bin_transformed)
  general_score <- signif(general_mean/5*100, 3)

  for (i in 1:length(trial_names)) {
    psychTestR::save_result(state, paste0("abs_", trial_names[i]), participant_distance_score[i])
  } # save absolute distance scores with a prefix 'abs_'

  for (i in 1:length(trial_names)) {
    psychTestR::save_result(state, paste0("bin_", trial_names[i]), bin_transformed[i])
  } # save bin scores with a prefix 'bin_'

  # save mean bin scores for each block & across blocks
  psychTestR::save_result(state, "tpt_env_score", signif(env_mean/5*100, 3))
  psychTestR::save_result(state, "tpt_flux_score", signif(flux_mean/5*100, 3))
  psychTestR::save_result(state, "tpt_cent_score", signif(cent_mean/5*100, 3))

  psychTestR::set_local("tpt_general_score", general_score, state)
  psychTestR::save_result(state, "tpt_general_score", general_score)
})

feedback <- psychTestR::join(
  psychTestR::reactive_page(function(state, ...){
    score <- psychTestR::get_local("tpt_general_score", state)
    psychTestR::one_button_page(shiny::div(
      shiny::p(
        "Your Timbre Perception Test score is:",
        shiny::strong(score)
      ),
      shiny::p("Well done!"),
      shiny::p(feed_plot(score))
    ))
  }
))

## Timeline----
all_pages <-  psychTestR::join(
  #instructions,
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
  researcher_email = "hlee@cbs.mpg.de",
  theme = shinythemes::shinytheme("united"),
  logo = "https://s3-eu-west-1.amazonaws.com/media.gold-msi.org/misc/img/logos/longgold_logo_transparent.png",
  logo_width = "200px",
  logo_height = "50px")}
