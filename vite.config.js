import { defineConfig } from "vite";
import createReScriptPlugin from "@jihchi/vite-plugin-rescript";
import fs from "fs";

const appDirectory = fs.realpathSync(process.cwd());
const isProduction = process.env.NODE_ENV === "production";

export default defineConfig({
  base: isProduction ? "/colisweb-rescript-api-parse/" : "",
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
