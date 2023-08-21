import { defineConfig } from "vite";
import createReScriptPlugin from "@jihchi/vite-plugin-rescript";

export default defineConfig({
  plugins: [
    createReScriptPlugin({
      loader: {
        output: "./lib/es6_global",
        suffix: ".bs.js",
      },
    }),
  ],
});
