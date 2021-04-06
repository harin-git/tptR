# Testing options to configure for standalone and demo
tpt_admin <- function(password, your_email, demo_ver = FALSE){
  psychTestR::test_options(
    title = 'Timbre Perception Test (TPT)',
    admin_password = password,
    researcher_email = your_email,
    theme = shinythemes::shinytheme("united"),
    demo = demo_ver)
}
