---
"ember-ui-sdk": minor
---

Type what Collapsible and Tabs yield. Their `part` modifier, `state`, `handle` and parts have precise types instead of `Record<string, any>`, so `c.Panel` and `c.part` check in strict templates with `noPropertyAccessFromIndexSignature`, and a misspelled part or a wrong argument is an error. `ember-ui-sdk/primitive` exports `RootYield` and `PartModifier` to type your own roots the same way.
