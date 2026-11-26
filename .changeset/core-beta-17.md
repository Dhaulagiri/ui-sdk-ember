---
"ember-ui-sdk": patch
---

Depend on `@ui-sdk/core` 0.1.0-beta.17, which brings its fixes from beta.14 to beta.17. Tabs scroll a clicked or arrowed-to tab into view, an Alert Dialog marks its other Close parts disabled while a close action runs, and a Popover's form no longer submits the form around it. The agent bridge finds a step's component behind closed tabs, sections and pages, `query` takes `closed` and `from`, `act` takes a `signal`, and a value change a callback cancels now fails its step. The docs in `ember-ui-sdk/docs` cover these, and add a page on running the model on your server.
