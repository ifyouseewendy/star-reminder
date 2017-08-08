const path = require("path");
const CleanWebpackPlugin = require("clean-webpack-plugin");

module.exports = {
  entry: "./src/index.js",
  output: {
    filename: "bundle.js",
    path: path.resolve(__dirname, "dist"),
  },
  module: {
    loaders: [
      { test: /\.js$/, loader: "babel-loader", exclude: /node_modules/ },
      { test: /\.css$/, use: ["style-loader", "css-loader"] },
    ],
  },
  plugins: [new CleanWebpackPlugin(["dist"])],
  devtool: "inline-source-map",
  devServer: {
    contentBase: "./src",
  },
};
