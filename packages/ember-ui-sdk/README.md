# ember-ui-sdk

UI SDK for Ember. A library of behaviors to build your components, rendered as Glimmer components.

Install with `pnpm add ember-ui-sdk`. Each component has its own entry point, such as `ember-ui-sdk/tabs`.

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
- A standard Ember addon build, such as Embroider with Vite. The v2 addon ships JavaScript and declarations. Portable templates use Ember's standard template-compilation API; no dependency `.gts`, TypeScript or decorator loaders are required.
- For template typechecking, use the `@glint/template` version required by your `@glint/ember-tsc`.

The classic-addon shim supports discovery by Ember CLI with ember-auto-import 2. The peer range allows Ember 5.12, 6.x and 7.x. Packed-package checks also cover Ember CLI 6.5 discovery, strict contextual declarations with `ember-tsc` 1.5.0, classic production compilation and focused tabs, dialog and combobox interactions. Ember 5.12 is not covered by a scenario yet.

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
| Element refs and actions | The `attach` modifier from `ember-ui-sdk/primitive`                       |
| Your own components      | `createParts`, `usePrimitive`, `usePart` from `ember-ui-sdk/primitive`    |

Every component in `@ui-sdk/core` is ported (51), with Shortcuts, Preferences and the overlay host for `toast()` and `confirm()`. Server rendering isn't supported.

## Docs

Docs and live examples: https://dhaulagiri.github.io/ui-sdk-ember/. The repository's `site/` serves the documentation; `pnpm --filter site dev` starts it. See `contributing/PORTING.md` for the porting recipe.

## Tests

- `pnpm test:upstream` runs the shared Playwright specs against the Ember playground.
- `pnpm test:package` checks a packed tarball and runs the isolated `test-app/` with QUnit, Testem and ember-try.
- `pnpm typecheck` checks the package, the fixtures and the examples with Glint.

`pnpm build` compiles the addon; `pnpm --filter ember-ui-sdk watch` rebuilds it while editing. `pnpm pack:local` writes `artifacts/ember-ui-sdk.tgz` for installation in another app without publishing. Packing always runs the build.
