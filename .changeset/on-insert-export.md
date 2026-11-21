---
"ember-ui-sdk": patch
---

`ember-ui-sdk/primitive` exports `onInsert`, a modifier that calls back with its element once it is in the page. Tracked state the callback sets renders a microtask later, and a function it returns runs when the element leaves. The resizable docs now give panels `@id`, which a panel's saved layout and a controller look up, not an `id` attribute.
