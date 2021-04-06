#' TPT_demo
#'
#' This is a quick demo version of the TPT. Only a single testing block is displayed
#' with a fake feedback score of 80 at the end.
#'
#' @param password default as 'demo'
#' @param your_email default as 'your-email@address'
#' @export
TPT_demo <- function(password = 'demo', your_email = "your-email@address") {
  demo_pages <- psychTestR::join(
    instructions,
    psychTestR::one_button_page(
      shiny::div(
        shiny::tags$h3("Demo - TPT"),
        shiny::tags$hr(),
        shiny::p("This is a quick demo version of the TPT"),
        shiny::p("Only a single testing block is shown with no feedback score at the end")
      ),
      button_text = "Begin demo"
    ),
    centBlock,
    psychTestR::one_button_page(shiny::div(
      shiny::p("*This is a demo feedback page that participants see at the end of the test*"),
      shiny::hr(),
      shiny::p("Well done for completing the test!"),
      shiny::p("Below is your estimated score out of 100"),
      shiny::p(feed_plot(80))
    )),
    psychTestR::final_page('Done. Now try the full version and receive a score!')
  )

  psychTestR::make_test(
    elts = demo_pages,
    opt = tpt_admin(password, your_email, demo_ver = TRUE)
  )
}
