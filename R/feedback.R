# This function transforms raw participant score to bin scores
bin_transform <- function(participant_abs_dist, target_value){
  max.dist <- NULL
  for(i in 1:length(participant_abs_dist)){
    if(target_value[i]<50){
      max.dist[i] <- 101 - target_value[i]
      participant_abs_dist[i] <- log((participant_abs_dist[i]+1) / max.dist[i] ) %/% (log(max.dist[i])/5)
    }
    else{
      max.dist[i] <- 1 + target_value[i]
      participant_abs_dist[i] <- log((participant_abs_dist[i]+1) / max.dist[i] ) %/% (log(max.dist[i])/5)
    }
  }
  abs(participant_abs_dist)
}

# for plotting gauge visualisation for participant feedback
feed_plot <- function(score){
  p <- plotly::plot_ly(
    domain = list(x = c(0, 1), y = c(0, 1)),
    value = score,
    title = list(text = "Your TPT Score"),
    type = "indicator",
    mode = "gauge+number",
    gauge = list(
      bar = list(color = "#8cc77f"),
      axis =list(range = list(0, 100)),
      steps = list(
        list(range = c(0, 20), color = "#ffe4b3"),
        list(range = c(20, 40), color = "#ffd58a"),
        list(range = c(40, 60), color = "#ffc65e"),
        list(range = c(60, 80), color = "#ffb836"),
        list(range = c(80, 100), color = "#ffa500"))
    ),
    height = 400,
    width = 500)

  plotly::layout(p, margin = list(l=20,r=30))
}

# this calculates scores for each block and saves to results
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
      shiny::p("Well done for completing the test!"),
      shiny::p("Below is your estimated score out of 100"),
      shiny::p(feed_plot(score))
    ))
  }
  ))

