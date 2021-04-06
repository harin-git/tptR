#' all three testing blocks that join demo and real sessions

page_after_block <- purrr::map(c(
    "Well done. You completed the first Block. Let's move on to the second one!",
    "You completed the second Block. One more to go!",
    "Fantastic! You now completed all the Blocks."
  ),
  psychTestR::one_button_page
)

# Envelope
envDemo <- makeDemoPage("Block 1", "env1", 15)
envItems <- purrr::map2(.x = paste0("env", 1:6), .y = "[ Block 1 ]", .f = makeTestPage)
envBlock <- psychTestR::join(
  psychTestR::code_block(function(state, ...) {
    psychTestR::set_local("do_practice", TRUE, state)
  }),
  psychTestR::while_loop(
    test = function(state, ...) psychTestR::get_local("do_practice", state),
    logic = envDemo
  ),
  psychTestR::randomise_at_run_time("env_order", logic = envItems),
  page_after_block[1]
)

# Flux
fluxDemo <- makeDemoPage("Block 2", "flux1", 75)
fluxItems <- purrr::map2(.x = paste0("flux", 1:6), .y = "[ Block 2 ]", .f = makeTestPage)
fluxBlock <- psychTestR::join(
  psychTestR::code_block(function(state, ...) {
    psychTestR::set_local("do_practice", TRUE, state)
  }),
  psychTestR::while_loop(
    test = function(state, ...) psychTestR::get_local("do_practice", state),
    logic = fluxDemo
  ),
  psychTestR::randomise_at_run_time("flux_order", logic = fluxItems),
  page_after_block[2]
)

# Centroid
centDemo <- makeDemoPage("Block 3", "cent1", 88)
centItems <- purrr::map2(.x = paste0("cent", 1:6), .y = "[ Block 3 ]", .f = makeTestPage)
centBlock <- psychTestR::join(
  psychTestR::code_block(function(state, ...) {
    psychTestR::set_local("do_practice", TRUE, state)
  }),
  psychTestR::while_loop(
    test = function(state, ...) psychTestR::get_local("do_practice", state),
    logic = centDemo
  ),
  psychTestR::randomise_at_run_time("cent_order", logic = centItems),
  page_after_block[3]
)
