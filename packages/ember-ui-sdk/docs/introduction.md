# Introduction

Use unstyled Ember components with keyboard, focus, and screen reader support built in.

These docs cover ui-sdk in Ember. Using another framework? See React, Vue, Svelte, Solid or Web Components. To build your own components from behaviors, see [Core](./core.md).

`ember-ui-sdk` gives you Glimmer components such as Tabs, Popover, and Select, built on ui-sdk's behaviors. They handle interactions, focus, and ARIA attributes. You choose their markup and styles.

Import a component's root, use the parts it yields, and style them with your own CSS.

## Quick Start

Copy this prompt into your agent:

```text prompt
Set up ui-sdk in this Ember project. It needs Ember 7 or newer, with template tag (.gts) components.

1. Install ember-ui-sdk and @ui-sdk/core with the project's package manager.
2. Add a note to AGENTS.md, creating it if needed: before using ui-sdk, follow the ui-sdk skill if it's installed, and read node_modules/ember-ui-sdk/docs/llms.txt. To build a new component, also search node_modules/ember-ui-sdk/docs/core.md by heading, and read rendering.md next to it.
3. If you support skills, run: npx skills add vercel-labs/ui --skill ui-sdk
```

It installs ui-sdk and points your `AGENTS.md` at the docs that ship with the packages.

## Set It Up Yourself

- [Installation](./installation.md): Install the packages in your Ember app.
- [Components](./README.md): Browse the components with live examples.
