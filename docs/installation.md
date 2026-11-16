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

The package ships `.gts` and `.ts` source with decorators, not compiled output. Your app's build has to compile that source, with the template tag, template compilation and decorator transforms applied to the package's files. [`playground/ember-plugin.ts`](https://github.com/Dhaulagiri/ui-sdk-ember/blob/main/playground/ember-plugin.ts) in the repository is a working Vite plugin that does this.

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
