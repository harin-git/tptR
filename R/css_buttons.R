#' This is the CSS styler for the clickable buttons
#' @export
button_style <- shiny::tags$style(
  ".button {
    display: inline-block;
    padding: 15px 25px;
    font-size: 16px;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    outline: none;
    color: black;
    background-color: #white;
    border: 2px solid #B2B2B2;
    border-radius: 15px;
    box-shadow: 0 9px #999;
    width: 180px;
    margin: 4px 10px;
  }

  .button:hover {
    background-color: #ffa500;
    color: white;
    border: 2px solid #ffa500;
  }

  .active {
    position: relative;
    animation: glowing 2000ms 1;
  }

  @keyframes glowing {
    0% {
      background-color: #ffa500;
      box-shadow: 0 5px ##999;
      border: 2px solid #ffa500;
      color: white;
    }
    80% {
      background-color: #ffa500;
      box-shadow: 0 0 30px #ffa500;
      border: 2px solid #ffa500;
      color: white;
      transform: translateY(4px);
    }
  }"
)
