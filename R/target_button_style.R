# makes the target sound button look fancy

target_button_style <- tags$style(
  ".button {
    display: inline-block;
    padding: 15px 25px;
    font-size: 20px;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    outline: none;
    color: #fff;
    background-color: #ffa500;
    border: none;
    border-radius: 15px;
    box-shadow: 0 9px #999;
  }

  .button:hover {
  	background-color: #ffd280;
  }

  @keyframes glowing {
    0% {
      background-color: #ffa500;
      box-shadow: 0 0 5px #ffa500;
    }
    16% {
      background-color: #ffd280;
      box-shadow: 0 0 20px #ffa500;
    }
    32% {
      background-color: #ffa500;
      box-shadow: 0 0 5px #ffa500;
    }
    48% {
      background-color: #ffa500;
      box-shadow: 0 0 5px #ffa500;
    }
    64% {
      background-color: #ffd280;
      box-shadow: 0 0 20px #ffa500;
    }
    80% {
      background-color: #ffa500;
      box-shadow: 0 0 5px #ffa500;
    }
  }

  .button:active {
    box-shadow: 0 5px #666;
    transform: translateY(4px);
    animation: glowing 2400ms;
  }
  "
)
