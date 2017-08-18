import React from "react";
import Image from "./logo.png";

const Logo = () => (
  <div className="logo">
    <img src={Image} alt="logo" />
    <p>Star Reminder</p>
  </div>
);

export default Logo;

