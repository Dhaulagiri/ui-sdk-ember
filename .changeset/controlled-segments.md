---
"ember-ui-sdk": patch
---

A controlled `DateInput` or `TimeInput` takes a new `@value` without Ember's backtracking assertion in development builds. A part now reads a change it hears during a render, like the new value `syncOptions` hands over, once the render ends.
