import "phoenix_html";

import React from "react";
import ReactDOM from "react-dom";

class HelloWorld extends React.Component {
  render() {
    return (<div>React - It`s Alive!</div>);
  }
}

ReactDOM.render(
  <HelloWorld/>,
  document.getElementById("test_react")
)
