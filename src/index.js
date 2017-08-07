import React from "react";
import ReactDOM from "react-dom";
import "./index.css";

window.Application = {
  render: function() {
    ReactDOM.render(<h1>Hello, world!</h1>, document.getElementById("root"));
  },
};

