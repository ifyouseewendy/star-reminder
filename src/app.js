import React from "react";
import injectTapEventPlugin from "react-tap-event-plugin";
import darkBaseTheme from "material-ui/styles/baseThemes/darkBaseTheme";
import getMuiTheme from "material-ui/styles/getMuiTheme";
import MuiThemeProvider from "material-ui/styles/MuiThemeProvider";
import RaisedButton from "material-ui/RaisedButton";

injectTapEventPlugin();

const App = (view) => {
  console.log(view);
  return (
    <div>
      <p>
        Apparently we had reached a great height in the atmosphere, for the sky was a dead black, and the stars had ceased to twinkle. By the same illusion which lifts the horizon of the sea to the level of the spectator on a hillside, the sable cloud beneath was dished out, and the car seemed to float in the middle of an immense dark sphere, whose upper half was strewn with silver. Looking down into the dark gulf below, I could see a ruddy light streaming through a rift in the clouds.
      </p>
      <MuiThemeProvider muiTheme={getMuiTheme(darkBaseTheme)}>
        <RaisedButton
          label="Github"
          href="/auth/github"
        />
      </MuiThemeProvider>
    </div>
  );
};

export default App;
