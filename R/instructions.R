# all instructions that are displayed at the beginning of the experiment

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

instruct1 <- psychTestR::one_button_page(div(
  tags$h3("Instructions"),
  hr(),
  tags$li("When you begin the test, you will hear a", tags$strong("taget sound")),
  tags$li("You can play the target sound anytime by clicking it"),
  tags$li("The slider bar below allows you to produce", tags$strong("your own sound")),
  tags$li("Your own sound will change as you move the slider"),
  tags$li("Your task is to match", tags$strong("your sound"), "to the", tags$strong("target sound"),"as close as possible"),
  br(),
  tags$img(src = paste0(image, "instruction1.png"), height = 110, width = 600),
  ), button_text = "I Get It"
)

instruct2 <- one_button_page(div(
  tags$h3("Instructions"),
  hr(),
  tags$li("The test is divided into 3 Blocks with 6 trials per Block"),
  tags$li("Moving the slider will change the sound differently in each Block"),
  tags$li("There will be a practice trial before each Block for you to become familiar with what the slider does"),
  br(),
  tags$img(src = paste0(image,"instruction2.png"), height = 120, width = 450),
  hr(),
  p("If you find any of this confusing, don't worry we got you covered."),
  p("In the next page, you'll have the chance to play around with the controls."),
  ), button_text = "Begin Practice Trial"
)

instructions <- join(landing, volumeCheck, playback, instruct1, instruct2)
