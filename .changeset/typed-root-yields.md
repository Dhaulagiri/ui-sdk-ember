---
"ember-ui-sdk": minor
---

Type what the roots yield. Collapsible, Tabs and 32 more roots now yield their `part` modifier, `state`, `handle` and parts with precise types instead of `Record<string, any>`, so `c.Panel` and `c.part` check in strict templates with `noPropertyAccessFromIndexSignature`, and a misspelled part or a wrong argument is an error. `ember-ui-sdk/primitive` exports `RootYield` and `PartModifier` to type your own roots the same way.
