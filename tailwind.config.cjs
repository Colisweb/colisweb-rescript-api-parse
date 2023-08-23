const config = require("@colisweb/rescript-toolkit/src/tailwind/tailwind.config.cjs");
module.exports = { ...config, content: [...config.content, "src/main.jsx"] };
