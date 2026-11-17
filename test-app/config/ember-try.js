const { resolve } = require("node:path")

module.exports = {
  npmOptions: [
    "--legacy-peer-deps",
    "--ignore-scripts",
    "--no-audit",
    "--no-fund",
  ],
  scenarios: [
    {
      name: "ember-7-vite",
      command: "npm run test:ember7",
      npm: {
        devDependencies: {
          "ember-ui-sdk": `file:${resolve(__dirname, "../../artifacts/ember-ui-sdk.tgz")}`,
        },
      },
    },
    {
      name: "ember-6.5-classic",
      command:
        "npm run test:packaging && ember build --environment production && ember test",
      env: { CLASSIC_BUILD: "true" },
      npm: {
        devDependencies: {
          "ember-source": "6.5.0",
          "ember-cli": "6.5.0",
          "ember-auto-import": "^2.13.0",
          "ember-cli-htmlbars": "^6.3.0",
          webpack: "^5.99.0",
          "@glint/ember-tsc": "1.5.0",
          "@glint/template": "1.7.7",
          "ember-ui-sdk": `file:${resolve(__dirname, "../../artifacts/ember-ui-sdk.tgz")}`,
        },
      },
    },
  ],
}
