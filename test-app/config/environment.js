module.exports = function (environment) {
  return {
    modulePrefix: "test-app",
    emberVersion: require("ember-source/package.json").version,
    environment,
    rootURL: "/",
    locationType: "none",
    EmberENV: { EXTEND_PROTOTYPES: false },
    APP:
      environment === "test"
        ? { autoboot: false, rootElement: "#ember-testing" }
        : {},
  }
}
