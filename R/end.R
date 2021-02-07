#' Ending pages that asks for participant ID or workerID and generate a random code.
#' It also sends an automated email to hlee(at)cbs.mpg.de
#' Together joined as 'end'
#' @export

participant <- psychTestR::get_p_id(htmltools::div(
  htmltools::p("Please enter your participant ID"),
  htmltools::p("*If you're a MTurk participant, enter your WorkerID")),
)

sendCode <- psychTestR::finish_test_and_give_code("hlee@cbs.mpg.de")
end <-  psychTestR::join(participant, sendCode)
