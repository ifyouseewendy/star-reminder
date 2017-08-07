import React from "react";
import ReactDOM from "react-dom";
import App from "./app";
import "./style.css";

window.addEventListener("load", () => {
  ReactDOM.render(<App />, document.getElementById("root"));
});
