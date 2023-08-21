import { defineConfig } from "vite";
import createReScriptPlugin from "@jihchi/vite-plugin-rescript";
import fs from "fs";

const appDirectory = fs.realpathSync(process.cwd());

export default defineConfig({
  plugins: [
    createReScriptPlugin({
      loader: {
        output: "./lib/es6_global",
        suffix: ".bs.js",
      },
    }),
  ],
  optimizeDeps: {
    include: ["highlight.js"],
  },
  resolve: {
    alias: [
      {
        find: "@root",
        replacement: (_) => appDirectory,
      },
    ],
  },
});
