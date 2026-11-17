# ember-ui-sdk

## 0.2.0

### Minor Changes

- 257ef2d: Publish a standard v2 Ember addon with compiled JavaScript, portable Ember templates, and declaration exports instead of raw TypeScript and `.gts` source. Preserve per-component imports and add the classic-addon shim so Ember CLI can discover the package.

  Declare the Glint template type peer and emit portable type references. Explicitly import template helpers and type the combobox's contextual components, including nested item, group and chip parts, for consumers with `noPropertyAccessFromIndexSignature`.

  Use standard addon module metadata so classic webpack builds correctly interoperate with Ember's AMD default exports. Avoid unavailable truth helpers in item-text rendering.

  Verify packed-package discovery, strict declarations, classic production compilation and focused tabs, dialog and combobox interactions on Ember 6.5, alongside the Ember 7/Vite path. Ember 7 remains the supported peer range; these focused checks do not establish general Ember 6.5 support.

## 0.1.0

### Minor Changes

- 6b5e983: First release of ember-ui-sdk: every ui-sdk component as Glimmer components.
