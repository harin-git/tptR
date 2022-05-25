#' all three testing blocks that join demo and real sessions

#page_after_block <- purrr::map(c(
#    psychTestR::i18n("AFTER_BLOCK1"),
#    psychTestR::i18n("AFTER_BLOCK2"),
#    psychTestR::i18n("AFTER_BLOCK3")
#  ),
#  function(x){
#    psychTestR::new_timeline(psychTestR::one_button_page(x),
#                             dict = tptR::TPT_dict)
#  }
#)

# Envelope
envBlock <- function(with_training = TRUE, dict = tptR::TPT_dict){
  if(with_training == TRUE){
    envDemo <- makeDemoPage("Block 1", "env1", 15, dict = dict)
    demo <- psychTestR::while_loop(
      test = function(state, ...) psychTestR::get_local("do_practice", state),
      logic = envDemo
    )
  } else {
    demo <- NULL
  }

  envItems <- purrr::map2(.x = paste0("env", 1:6), .y = "[ Block 1 ]", .f = makeTestPage)
  out <- psychTestR::join(
    psychTestR::code_block(function(state, ...) {
      psychTestR::set_local("do_practice", TRUE, state)
    }),
    demo,
    psychTestR::randomise_at_run_time("env_order", logic = envItems),
    psychTestR::new_timeline(psychTestR::one_button_page(psychTestR::i18n("AFTER_BLOCK1")),
                             dict = tptR::TPT_dict)
  )

  return(out)
}



# Flux
fluxBlock <- function(with_training = TRUE, dict = tptR::TPT_dict){
  if(with_training == TRUE){
    fluxDemo <- makeDemoPage("Block 2", "flux1", 75, dict = dict)
    demo <- psychTestR::while_loop(
      test = function(state, ...) psychTestR::get_local("do_practice", state),
      logic = fluxDemo
    )
  } else {
    demo <- NULL
  }

  fluxItems <- purrr::map2(.x = paste0("flux", 1:6), .y = "[ Block 2 ]", .f = makeTestPage)
  out <- psychTestR::join(
    psychTestR::code_block(function(state, ...) {
      psychTestR::set_local("do_practice", TRUE, state)
    }),
    demo,
    psychTestR::randomise_at_run_time("flux_order", logic = fluxItems),
    psychTestR::new_timeline(psychTestR::one_button_page(psychTestR::i18n("AFTER_BLOCK2")),
                             dict = tptR::TPT_dict)
  )

  return(out)
}


# Centroid
centBlock <- function(with_training = TRUE, dict = tptR::TPT_dict){
  if(with_training == TRUE){
    centDemo <- makeDemoPage("Block 3", "cent1", 88, dict = dict)
    demo <- psychTestR::while_loop(
      test = function(state, ...) psychTestR::get_local("do_practice", state),
      logic = centDemo
    )
  } else {
    demo <- NULL
  }

  centItems <- purrr::map2(.x = paste0("cent", 1:6), .y = "[ Block 3 ]", .f = makeTestPage)
  out <- psychTestR::join(
    psychTestR::code_block(function(state, ...) {
      psychTestR::set_local("do_practice", TRUE, state)
    }),
    demo,
    psychTestR::randomise_at_run_time("cent_order", logic = centItems),
    psychTestR::new_timeline(psychTestR::one_button_page(psychTestR::i18n("AFTER_BLOCK3")),
                             dict = tptR::TPT_dict)
  )

  return(out)
}


