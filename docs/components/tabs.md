---
title: Tabs
description: Switch between related panels with one tab selected at a time.
---

Use Tabs when several views share the same space, such as settings sections or a preview and its source. Each tab opens the panel with the same value.

[tabs/basic](../../examples/components/tabs/ember/basic.gts)

Choose Password to show its panel. Use the left and right arrow keys to move between the tabs.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

`Tabs` yields its parts. Use the following composition:

```text
Tabs as |t|
├── t.List
│   ├── t.Tab
│   └── t.Tab
├── t.Panel
└── t.Panel
```

Give each tab and its panel the same unique `@value`. Give the list an accessible name. Set `@defaultValue` to choose the initial tab; otherwise, the first enabled tab is selected.

## Usage

Import the root and use the parts it yields:

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

`ember-ui-sdk/tabs` also exports each part by name, such as `TabsList` and `TabsTab`. They take the root's `@handle`, so use the parts the root yields instead.

## Vertical

Set `@orientation="vertical"` to use Up and Down Arrow instead. Style the list as a column beside the panels to match.

[tabs/vertical](../../examples/components/tabs/ember/vertical.gts)

Focus General, then press Down Arrow to choose Security. Up Arrow moves back through the vertical list.

## Disabled

Add `@disabled={{true}}` to a tab to prevent selection. Arrow keys can still focus it so people can discover it.

[tabs/disabled](../../examples/components/tabs/ember/disabled.gts)

Use the arrow keys to reach Reports. It can receive focus, but pressing it leaves the current panel selected.

## Icons

Put decorative icons in `t.TabIcon` so they stay out of the tab’s accessible name. Add `@mirror={{true}}` to directional icons, such as Reply, to flip them in right-to-left text. An icon-only tab still needs an `aria-label`.

[tabs/icons](../../examples/components/tabs/ember/icons.gts)

Choose Replies. Its directional icon mirrors when the surrounding page uses right-to-left text.

## Manual Activation

Set `@activation="manual"` when opening a panel takes time, such as a view that fetches data. Arrow keys move focus; Enter or Space selects the focused tab.

```gts
<Tabs @activation="manual" as |t|>…</Tabs>
```

A panel becomes a tab stop only when it has no focusable content. A panel with a field lets Tab go straight to the field.

[tabs/manual](../../examples/components/tabs/ember/manual.gts)

Focus Preview, then press Right Arrow. Code receives focus; press Enter or Space to show its panel. Tab then moves into the Source field.

## Loop

Arrow keys normally wrap around at either end. Set `@loop={{false}}` to stop there instead.

[tabs/loop](../../examples/components/tabs/ember/loop.gts)

Focus Year and press Right Arrow. Focus stays at the end because looping is off.

## Indicator

`t.Indicator` measures the selected tab. Position it inside a relative tab list and use its [CSS variables](#tabsindicator) to make a marker that follows the selection. It measures again when a tab or the list changes size.

```css
[data-slot="tabs-list"] {
  position: relative;
}

[data-slot="tabs-indicator"] {
  position: absolute;
  top: var(--active-tab-top);
  left: var(--active-tab-left);
  width: var(--active-tab-width);
  height: var(--active-tab-height);
  transition-property: top, left, width, height;
  transition-duration: 200ms;

  &[data-activation-direction="none"] {
    transition: none;
  }
}
```

Add transitions for the properties you animate. Skip them while `data-activation-direction="none"` to avoid animating the first placement.

[tabs/indicator](../../examples/components/tabs/ember/indicator.gts)

Choose Podcasts, then choose Vertical. The same indicator measures and follows the selected tab in either layout.

## Keep Mounted

Panels normally unmount when another tab is selected. Add `@keepMounted={{true}}` to a panel to keep its content hidden in the page, preserving local state such as a draft.

[tabs/keep-mounted](../../examples/components/tabs/ember/keep-mounted.gts)

Write a message, switch to Formatting, then return to Reply. Your draft is still there.

## Find in Page

Add `@hiddenUntilFound={{true}}` to the tabs or a panel to keep closed content available to the browser’s Find command. A match selects its tab with the reason `find-in-page`. This also keeps the panel mounted.

[tabs/find-in-page](../../examples/components/tabs/ember/find-in-page.gts)

Use your browser’s Find command to search for “restocking fee”. Returns opens to reveal the match.

## Animation

Panels expose `data-starting-style` as they enter and `data-ending-style` as they leave. The previous panel stays mounted through its exit animation, then unmounts or hides if it is kept mounted.

Use `data-activation-direction` to choose a slide direction. Put the panels in the same grid cell so they overlap during the transition, as this example does.

[tabs/animation](../../examples/components/tabs/ember/animation.gts)

Move between Overview, Activity and Settings. The panels slide in the direction you moved.

## Controlled

Pass `@value` and update it in `@onValueChange` to own the selected tab. Call `details.cancel()` in the change callback to reject a change.

`@onValueChange` receives the new value and a [reason](https://ui-sdk.dev/docs/react/components/tabs#reasons), such as `item-press`, `list-navigation`, or `imperative`. It does not run for the initial selection. A controller, from `createTabsController()` and passed as `@controller`, lets another control select a tab too.

[tabs/controlled](../../examples/components/tabs/ember/controlled.gts)

Choose Drafts, then press Show Sent Mail. The console logs each new value with its reason.

## Links

Render a tab as a link when selection should navigate. It keeps its tab role; arrow keys follow the link when they select it. Modified clicks, such as Cmd-click, keep their normal browser behavior without selecting the tab.

```gts
<t.Tab @value="activity" @render={{true}} as |tab|>
  <a href="#activity" {{tab.part}}>Activity</a>
</t.Tab>
```

[tabs/links](../../examples/components/tabs/ember/links.gts)

Choose Activity. Its panel opens and the URL hash changes. Modified clicks keep the link’s usual browser behavior.

## Query String

Use the URL as the source of the selected value, and validate it against your tab values. Read the parameter on the server when possible, then pass it as the controlled value. Write changes through your router so browser navigation and the rendered page stay in sync. For a plain client page, keep the rest of the URL when updating it:

```ts
function saveSelectedTab(value: string | null) {
  const url = new URL(location.href)
  if (value === null) {
    url.searchParams.delete("tab")
  } else {
    url.searchParams.set("tab", value)
  }
  history.replaceState(null, "", url)
}
```

Call this from `@onValueChange` after accepting the value. Read it again on `popstate` if your page uses browser history directly; remove that listener when the view unmounts.

## URL Hash

A hash such as `#activity` works on a client-rendered page. Read it after mount and on `hashchange`, then select the matching tab. Setting `location.hash` adds a history entry. The server cannot read the hash, so give the page an initial tab while it loads.

## Route Tabs

When each tab is a route, render [links](#links) and derive the controlled value from the current path. Let navigation update the value. You do not also need a change handler that navigates to the same route.

## Scroll into View

If the list scrolls, selecting a tab scrolls it into view inside that list, whether you click it, reach it with an arrow key, or select it through a controller or the URL.

## Custom Rendering

Pass `@render={{true}}` to render a part as your own element. The part yields `{ part, state }`: bind `part` to your element as a modifier, as in the [links](#links) example, and read `state` to add to its content. Each part’s state is listed under [State](https://ui-sdk.dev/docs/react/components/tabs#state).

[tabs/render](../../examples/components/tabs/ember/render.gts)

Each tab renders its own button with an unread count after the label. Choose Unread to see who wrote to you.

## Styling

Parts are unstyled. Use `data-selected` and `data-disabled` to style a tab, and `data-selected` on a panel that shows. `data-orientation` on every part lets one stylesheet lay out horizontal and vertical tabs. Icon parts also set `data-has-icon` on the tab and `data-has-icons` on the list, which can help align mixed text and icon tabs.

The indicator’s position and size are measured from the tab list into the variables below. Use them for an underline, a background, or a marker beside a vertical list.

Each part has a `data-slot`, such as `tabs-tab`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/tabs#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [tabs reference](https://ui-sdk.dev/docs/react/components/tabs) in the upstream docs.

Options and callbacks are passed as arguments: `@value`, `@onValueChange`. Every part also takes `@render`.

### TabsList

The list takes no options of its own, only the attributes of the element it renders.

### TabsIndicator

The indicator takes no arguments of its own. Its [CSS variables](#tabsindicator) hold the selected tab's box.

### Controller

Create one with `createTabsController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs `@onValueChange` like a press, and returns `false` when the change is canceled.

### Events

Callbacks get the new value first, then the details. `@onValueChange` never runs on mount.

| Argument         | On     | Receives                                                                                                   |
| ---------------- | ------ | ---------------------------------------------------------------------------------------------------------- |
| `@onValueChange` | `Tabs` | `(value, details)`: the new value, and the [reason](https://ui-sdk.dev/docs/react/components/tabs#reasons) |

## Accessibility

Tabs follow the [WAI-ARIA tabs pattern](https://www.w3.org/WAI/ARIA/apg/patterns/tabs/). The list is a `tablist`, each tab controls its panel, and each panel is labelled by its tab.

### Keyboard

Tab enters the list at the selected tab and leaves it on the next Tab. Left and Right Arrow move between tabs and select them, or only move focus with `@activation="manual"`, where Enter or Space selects. Up and Down Arrow do the same in a vertical list. Home and End move to the first and last tabs. The list reads `dir="rtl"` from the page or any ancestor, and Left and Right follow the reading direction, with no provider.
