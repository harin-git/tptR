#' This custom script for moveable slider that records slider position
#' @param trialName If file is called 'env_13.mp3', 'env' is the trialName and the function maps
#' slider values from 0 to 100. Eg, env_01, env_02, env_03...
sliderJS <- function(trialName) {
  shiny::HTML(
    sprintf(
      "var yourAudio = new Audio();
    var slider = document.getElementById('slider');

    function export_answer(value) {
      Shiny.onInputChange('slider', value);
    }

    function playYourAudio() {
      console.log('hi');
      var value = slider.value;
      export_answer(value);
      document.getElementById('targetAudio').pause();
      document.getElementById('targetAudio').currentTime = 0;
      var url = '%s' + '_' + value + '.mp3';
      yourAudio.pause();
      yourAudio = new Audio(url);
      yourAudio.play();
      let elem = document.getElementById('yourSound');
      elem.classList.remove('active');
      elem.classList.add('active');
      setTimeout(function () {
        elem.classList.remove('active');
      }, 2000);
    }

    function playTargetAudio(elem) {
      yourAudio.pause();
      document.getElementById('targetAudio').currentTime = 0;
      document.getElementById('targetAudio').play();
      elem.classList.remove('active');
      elem.classList.add('active');
      setTimeout(function () {
        elem.classList.remove('active');
      }, 2000);
    }

    export_answer(slider.value);
    slider.addEventListener('change', playYourAudio);
    yourSound.addEventListener('click', playYourAudio);
    ", paste0(audio, trialName)
    )
  )
}
