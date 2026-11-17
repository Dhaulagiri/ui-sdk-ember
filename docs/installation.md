---
title: Installation
description: Install ember-ui-sdk in your Ember app.
---

Start with an app using Ember 7 or newer, with template tag components in `.gts` files.

## Install the Packages

```bash
pnpm add ember-ui-sdk
```

It depends on `@ui-sdk/core`, which installs with it. It needs these peers in your app: `ember-source` 7 or newer, `@glimmer/component` 2 or newer and `@glimmer/tracking`.

The package is a v2 Ember addon with JavaScript and declaration exports for each component. Templates use Ember's standard template-compilation API and are compiled by your app's Ember compiler. Your app does not need to parse dependency `.gts` files, strip TypeScript, or transform the SDK's decorators.

For template typechecking, install the `@glint/template` version required by your `@glint/ember-tsc`. Multiple incompatible copies can cause invokable-type errors.

The package includes the standard classic-addon shim for discovery by Ember CLI with ember-auto-import 2. The supported peer remains Ember 7. Packed-package checks also cover Ember CLI 6.5 discovery, strict contextual declarations with `ember-tsc` 1.5.0, classic production compilation and focused tabs, dialog and combobox interactions. This limited coverage does not establish general Ember 6.5 support.

## Use a Component

Import each component's root from its own entry. The root yields its parts, so a template needs only the one import:

```gts
import { Tabs } from "ember-ui-sdk/tabs"

<template>
  <Tabs @defaultValue="account" as |t|>
    <t.List aria-label="Settings">
      <t.Tab @value="account">Account</t.Tab>
      <t.Tab @value="password">Password</t.Tab>
    </t.List>
    <t.Panel @value="account">Manage your profile.</t.Panel>
    <t.Panel @value="password">Choose a new password.</t.Panel>
  </Tabs>
</template>
```

Options are arguments, like `@defaultValue`, and callbacks are arguments too, like `@onValueChange`. HTML attributes, like `aria-label`, go to the part's element. Each entry also exports every part by name, like `TabsList`. These take the root's `@handle` and are for building your own roots, so use the yielded parts instead.

Each [component page](./components/index.md) lists the parts a root yields.

## Add Your Styles

Components are unstyled, so you style them with your app's CSS or with Tailwind CSS. Every part sets a `data-slot`, such as `tabs-tab`, and its state as data attributes, such as `data-selected`.

For a default look to start from, import `@ui-sdk/core/web.css` once, at the top of your app's entry:

```ts
import "@ui-sdk/core/web.css"
```

With Tailwind CSS, import it in your global stylesheet instead, after Tailwind. `layer(components)` puts it above Tailwind's base styles, so they don't reset it, and below its utilities, so a class still wins:

```css
@layer ui-sdk;

@import "tailwindcss";
@import "@ui-sdk/core/web.css" layer(components);
```

You can render your first component without setting up a provider or adding a portal root.

## Right to Left

Set `dir="rtl"` on the page or a container. Arrow keys and popup placement follow that direction without a provider. Use logical CSS properties, such as `padding-inline-start`, for your styles.
