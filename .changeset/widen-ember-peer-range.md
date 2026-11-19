---
"ember-ui-sdk": patch
---

Widen the `ember-source` peer range to `^5.12.0 || ^6.0.0 || ^7.0.0`. The addon uses no Ember 7-only API, so apps on Ember 5.12 LTS and 6.x no longer get a peer-dependency warning.
