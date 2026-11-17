module.exports = function (environment) {
  return {
    modulePrefix: "test-app",
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
