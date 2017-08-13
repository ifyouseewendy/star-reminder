import React from "react";
import ReactDOM from "react-dom";
import "whatwg-fetch";
import "@shopify/polaris/styles.css";
import { AppContainer } from "react-hot-loader";
import App from "./app";
import "./style.css";

const render = (Component, payload) => {
  ReactDOM.render(
    <AppContainer>
      <Component {...payload} />
    </AppContainer>,
    document.getElementById("root"),
  );
};

const fetchUser = () => {
  fetch("/user", { credentials: "same-origin" })
    .then(response => response.json())
    .then(payload => render(App, payload))
    .catch((ex) => {
      console.log("parsing failed", ex);
    });
};

if (module.hot) {
  module.hot.accept("./app", () => {
    fetchUser();
  });
}

fetchUser();
