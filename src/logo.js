import React from "react";
import Image from "./logo.png";

const Logo = () => (
  <div className="logo">
    <div className="logo--container">
      <img src={Image} alt="logo" />
      <p>Star Reminder</p>
    </div>
  </div>
);

export default Logo;

