#' Instructions & AWS S3 directory
#' This directory should be changed to where it should be hosted
audio <- "https://hleetestbuck.s3.eu-central-1.amazonaws.com/TPT_resources/audio/"
image <- "https://hleetestbuck.s3.eu-central-1.amazonaws.com/TPT_resources/image/"

landing <- psychTestR::one_button_page(
  shiny::div(
    shiny::tags$h3("Do you have good ears for discriminating sounds?"),
    shiny::tags$hr(),
    shiny::p("This test examines your ability to match one sound to another"),
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
    shiny::tags$li(shiny::tags$strong("Taget Sound"), "is fixed and can be played anytime by clicking it."),
    shiny::tags$li(shiny::tags$strong("Your Sound"), " changes when you move the slider. You can click to hear the change you made."),
    shiny::tags$li("At any point, whichever sound that is playing will be indicated with an orange glow."),
    shiny::tags$li("Your task is to fine-tune", shiny::tags$strong("Your Sound"),
                   "to match the", shiny::tags$strong("Target Sound.")),
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
