---
title: Avatar
description: Show an image with a fallback while it loads or if it fails.
---

Use an Avatar for a person or a team, like in a comment, a member list or an account menu. It shows initials or an icon until the image loads, and keeps showing them if the image fails.

[avatar/basic](../../examples/components/avatar/ember/basic.gts)

The image replaces the initials once it loads. A screen reader can read the person's name in either state.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build an `Avatar`:

```text
Avatar as |a|
├── a.Image
└── a.Fallback
```

- `Avatar` shares the image's loading state with its parts.
- `a.Image` renders the image.
- `a.Fallback` shows when no image is loaded.

The image is a real `img`, including in server markup. The browser can start fetching it before hydration. The fallback stays visible until the image loads; if loading fails, the fallback remains.

## Usage

Import the root and use the parts it yields:

```gts
import { Avatar } from "ember-ui-sdk/avatar"

<template>
  <Avatar as |a|>
    <a.Image @src="/ada.png" alt="Ada Lovelace" />
    <a.Fallback>AL</a.Fallback>
  </Avatar>
</template>
```

`ember-ui-sdk/avatar` also exports each part by name, such as `AvatarImage` and `AvatarFallback`. They take the root's `@handle`, so use the parts the root yields instead.

## Fallback Delay

<span id="behavior-and-options" />

Set `@delay` on the fallback to wait before showing it, in milliseconds. This avoids flashing initials when an image loads quickly. Without a delay, the fallback appears immediately, including on the server.

```gts
<Avatar as |a|>
  <a.Image @src="https://github.com/shadcn.png" alt="shadcn" />
  <a.Fallback @delay={{600}}>CN</a.Fallback>
</Avatar>
```

## Image Attributes

Pass image attributes such as `srcset`, `crossorigin`, and `referrerpolicy` to the image. They work on the same `img` the browser loads. For avatars farther down a page, use `loading="lazy"`.

```gts
<Avatar as |a|>
  <a.Image
    @src="https://github.com/shadcn.png"
    srcset="https://github.com/shadcn.png?size=80 1x, https://github.com/shadcn.png?size=160 2x"
    alt="shadcn"
    crossorigin="anonymous"
    referrerpolicy="no-referrer"
    loading="lazy"
  />
  <a.Fallback>CN</a.Fallback>
</Avatar>
```

## Interactive Avatar

Put the avatar inside a button when clicking it performs an action. Give the button an accessible name that stays available while the image loads, and hide the decorative fallback from screen readers.

```gts
<button type="button" aria-label="shadcn" {{on "click" this.openProfile}}>
  <Avatar as |a|>
    <a.Image @src="https://github.com/shadcn.png" alt="" />
    <a.Fallback><span aria-hidden="true">CN</span></a.Fallback>
  </Avatar>
</button>
```

## Loading Status

`@onLoadingStatusChange` receives the new status and change details. The possible statuses are `loading`, `loaded`, `error`, and `idle`.

```gts
<Avatar @onLoadingStatusChange={{this.onStatus}} as |a|>
  <a.Image @src={{user.image}} alt={{user.name}} />
  <a.Fallback>{{user.initials}}</a.Fallback>
</Avatar>
```

When you replace a loaded image, the browser keeps it visible while the next source loads. A failed replacement shows the fallback. The change details explain why the status changed; see [Reasons](https://ui-sdk.dev/docs/react/components/avatar#reasons).

## Custom Rendering

Pass `@render={{true}}` to a part to render your own element. The part yields `{ part, state }`, and every part receives the loading status, so the fallback can say something different when the image fails:

```gts
<Avatar as |a|>
  <a.Image @src={{user.image}} alt={{user.name}} />
  <a.Fallback @render={{true}} as |f|>
    <span {{f.part}}>{{if (eq f.state.loadingStatus "error") "?" user.initials}}</span>
  </a.Fallback>
</Avatar>
```

## Styling

Set the root's size and let the image and fallback fill it. The image manages its own hidden styles until it loads; keep those styles intact when changing its element.

Each part has a `data-slot`, such as `avatar-fallback`, and shows the loading status through the attributes listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/avatar#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [avatar reference](https://ui-sdk.dev/docs/react/components/avatar) in the upstream docs.

Options and callbacks are passed as arguments, such as `@delay` and `@onLoadingStatusChange`. Every part also takes `@render`.

### AvatarImage

The image. Renders a real `img`, so the browser can fetch it before hydration, and accepts its attributes, such as `srcset`, `crossorigin` and `referrerpolicy`.

### Events

Callbacks get the new status first, then the details.

| Argument                 | On       | Receives                                                                                                                           |
| ------------------------ | -------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `@onLoadingStatusChange` | `Avatar` | `(status, details)`: the image's status, the [reason](https://ui-sdk.dev/docs/react/components/avatar#reasons) and `details.event` |

## Accessibility

Give the image meaningful `alt` text. Include the person's name in the fallback too, using visually hidden text if you only want to show initials.

When a visible name beside the avatar already identifies the person, use an empty `alt` and hide decorative fallback content from screen readers.
