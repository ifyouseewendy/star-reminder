import React from "react";
import ReactDOM from "react-dom";
import { AppContainer } from "react-hot-loader";
import App from "./app";
import "./style.css";

const render = (view) => {
  ReactDOM.render(
    <AppContainer>
      <App {...view} />
    </AppContainer>,
    document.getElementById("root"),
  );
};

window.Application = {
  render,
};
