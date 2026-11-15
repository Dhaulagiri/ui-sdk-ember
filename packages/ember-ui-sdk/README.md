# ember-ui-sdk

UI SDK for Ember. A library of behaviors to build your components, rendered as Glimmer components.

> **Not published.** This package lives in a fork of [vercel-labs/ui](https://github.com/vercel-labs/ui) and isn't on npm. Use it from this repo, as a workspace package or a git dependency.

It renders the same `@ui-sdk/core` behaviors as `@ui-sdk/react`, `vue`, `svelte`, `solid` and `web`: keyboard navigation, focus, selection, dismissal, popups and the ARIA they need. You write the markup and styles. State shows up as data attributes and CSS variables.

```gts
import { Tabs } from "ember-ui-sdk/tabs"

<template>
  <Tabs @defaultValue="account" as |t|>
    <t.List aria-label="Settings">
      <t.Tab @value="account">Account</t.Tab>
      <t.Tab @value="password">Password</t.Tab>
    </t.List>
    <t.Panel @value="account">Update your name and email.</t.Panel>
    <t.Panel @value="password">Choose a new password.</t.Panel>
  </Tabs>
</template>
```

## Requirements

- `ember-source` 7, `@glimmer/component` and `@glimmer/tracking` as peers. `@ui-sdk/core` is a dependency.
- The package ships `.gts` and `.ts` source with decorators, so the app's build compiles it: Embroider with Vite, with the template-tag and decorator transforms. `apps/playground/ember-plugin.ts` is a working setup.

## How it maps to the other frameworks

| Concept                  | Ember                                                                     |
| ------------------------ | ------------------------------------------------------------------------- |
| Parts                    | The root yields them: `<Select as \|s\|><s.Trigger>`                      |
| Options and props        | Arguments: `@defaultValue`, `@disabled`                                   |
| Callbacks                | `@onValueChange`, `@onOpenChange`                                         |
| Controlled values        | `@value` plus `@onValueChange` writing `@tracked` state                   |
| `render` (any element)   | `@render={{true}}` yields `{ part, state }`; put `{{x.part}}` on your tag |
| Context                  | None in Ember: parts get their root through the yield or `@handle`        |
| Fields                   | Controls inside a Field take `@field={{f.field}}`                         |
| Element refs and actions | The `attach` modifier from `ember-ui-sdk/primitive`                      |
| Your own components      | `createParts`, `usePrimitive`, `usePart` from `ember-ui-sdk/primitive`   |

Every component in `@ui-sdk/core` is ported (51), with Shortcuts, Preferences and the overlay host for `toast()` and `confirm()`. Server rendering isn't supported.

## Docs

The docs site in `apps/docs` has Ember in its Frameworks menu: an installation page, a rendering page, every component page with live `.gts` examples, and Ember tabs on the Core and Guides pages. Run `pnpm dev` and open `/docs/ember/components/tabs`. `PORTING.md` is the recipe for porting a component, and `handoff/` holds the notes from the port.

## Tests

- The Playwright specs every framework shares run on the `ember` and `ember-data` projects: `cd tests && npx playwright test --project ember`.
- `tests/ember-examples.spec.ts` opens every Ember docs example in a browser and fails on any error.
- `pnpm typecheck` checks the package, the fixtures and the examples with Glint.
