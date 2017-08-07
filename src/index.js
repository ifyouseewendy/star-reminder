import React from "react";
import ReactDOM from "react-dom";
import App from "./app";
import "./index.css";

window.Application = {
  render() {
    ReactDOM.render(<App />, document.getElementById("root"));
  },
};

