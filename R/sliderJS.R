#' An HTML script for calling audio file when moving the slider
#' @export

sliderJS <- function(trialName){
  HTML(sprintf("var audio = new Audio();
    var slider = document.getElementById('slider');

    function export_answer(value) {
      Shiny.onInputChange('slider', value);
    }

    function play_audio() {
      console.log('hi');
      var value = slider.value;
      export_answer(value);
      var url = '%s' + '_' + value + '.mp3';
      audio.pause();
      audio = new Audio(url);
      audio.play();
    }

    export_answer(slider.value);
    slider.addEventListener('change', play_audio)
    ",
    paste0(audio, trialName)
  ))
}
