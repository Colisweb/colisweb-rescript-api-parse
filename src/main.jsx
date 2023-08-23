import React from "react";
import ReactDOM from "react-dom/client";
import { make as App } from "../lib/es6_global/src/App.bs";
import "@colisweb/rescript-toolkit/src/ui/styles.css";
import "./main.css";

const root = ReactDOM.createRoot(document.getElementById("root"));

root.render(<App />);
