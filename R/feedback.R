#' Three things are happening here:
#'
#' 1) The original data collected over N = 94 in the published paper is stored
#' in the directory 'tpt_data/TPT_rawDistance.csv'. This is raw absolute distances
#' from the target value and is different to the score calculated in the paper using
#' six bin scores. The absolute distance (i.e. slider distance away from the answer)
#' here is used to generate an estimate of performance for
#' participants taking this online version test
#'
#' 2) The 'score_calculation' function is called at the end of the experiment
#' with all participant's response for every trial. Next, absolute distance is calculated
#' by the distance away from the new_target_values and then computes a score out of 100.
#' The score to give as feedback is stored in the 'feedback_score'. Also the percentile is
#' computed and stored in 'abs_distance_quantile'.
#'
#' 3) The 'feedback' page returns the feedback_score and abs_distance_quantile to
#' display as feedback to the participant at the end of the experiment.
#' **Note that this is only to give an estimate and should NOT be used to record
#' as the actual participant performance!
#'
#' @export score_calculation
#' @export feedback

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
