# Avatar

Show an image with a fallback while it loads or if it fails.

Use an Avatar for a person or a team, like in a comment, a member list or an account menu. It shows initials or an icon until the image loads, and keeps showing them if the image fails.

```glimmer-ts title="basic.gts"
import { Avatar } from "ember-ui-sdk/avatar"

const person = {
  name: "shadcn",
  src: "https://github.com/shadcn.png",
}

<template>
  <div data-slot="row">
    <Avatar as |a|>
      <a.Image @src={{person.src}} alt={{person.name}} />
      <a.Fallback><span aria-hidden="true">CN</span><span
          data-slot="visually-hidden"
        >shadcn</span></a.Fallback>
    </Avatar>
  </div>
</template>
```

The image replaces the initials once it loads. A screen reader can read the person's name in either state.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

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

`ember-ui-sdk/avatar` also exports each part by name, such as `AvatarImage` and `AvatarFallback`.

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

When you replace a loaded image, the browser keeps it visible while the next source loads. A failed replacement shows the fallback. The change details explain why the status changed; see [Reasons](#reasons).

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

Each part has a `data-slot`, such as `avatar-fallback`, and shows the loading status through the attributes listed under [Data Attributes](#data-attributes).

## Data Attributes

### Avatar
`[data-slot="avatar"]`

- `data-loading-status` (`idle`, `loading`, `loaded`, `error`): Where the image is: no image yet, loading, loaded, or failed.

### AvatarImage
`[data-slot="avatar-image"]`

- `data-loading-status` (`idle`, `loading`, `loaded`, `error`): Where the image is: no image yet, loading, loaded, or failed.

### AvatarFallback
`[data-slot="avatar-fallback"]`

- `data-loading-status` (`idle`, `loading`, `loaded`, `error`): Where the image is: no image yet, loading, loaded, or failed.

## API Reference

Options and callbacks are the same as below, as arguments, such as `@delay` and `@onLoadingStatusChange`. Every part also takes `@render`.

### Avatar

- `onLoadingStatusChange?` (`((status: AvatarLoadingStatus, details: ChangeDetails<AvatarLoadingStatusChangeReason>) => void)`): Runs when the image's loading status changes: `"loading"` when it gets a source, `"loaded"`, `"error"`, and `"idle"` when it leaves the page. `details.reason` says why, and `details.event` is the image's `load` or `error` event, or undefined when the status was known at once, like for a cached image.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### AvatarImage

The image. Renders a real `img`, so the browser can fetch it before hydration, and accepts its attributes, such as `srcset`, `crossorigin` and `referrerpolicy`.

### AvatarFallback

- `delay?` (`number`): How long to wait, in milliseconds, before showing the fallback, so a fast image appears without the fallback flashing first. Without one, the fallback shows at once, server markup included.

### State

What `@render={{true}}` yields as `state`. Every part gets the same state.

- `loadingStatus` (`AvatarLoadingStatus`): Where the image is: `"idle"`, `"loading"`, `"loaded"` or `"error"`.

### Reasons

`details.reason` says why the status changed.

- `image-load` (`Event | undefined`): An image loaded. No event when it was already in the browser's cache.
- `image-error` (`Event | undefined`): An image failed to load, or has no source. No event when that was known at once.
- `src-change` (`none`): An image got a new source, or left the page, so its status starts over.

### Events

Callbacks get the new status first, then the details.

| Argument                 | On       | Receives                                                                            |
| ------------------------ | -------- | ----------------------------------------------------------------------------------- |
| `@onLoadingStatusChange` | `Avatar` | `(status, details)`: the image's status, the [reason](#reasons) and `details.event` |

## Accessibility

Give the image meaningful `alt` text. Include the person's name in the fallback too, using visually hidden text if you only want to show initials.

When a visible name beside the avatar already identifies the person, use an empty `alt` and hide decorative fallback content from screen readers.

- An image that loads replaces the fallback.
- An image that fails keeps the fallback.
- An avatar without an image shows its fallback.
- A fallback with a delay waits before showing.
- The image's loading status is reported.
- Removing the image brings the fallback back.
- A new source shows its image once it loads.
- The image is fetched with its own referrer policy.
- A cached image doesn't flash the fallback when the avatar mounts again.
- A new source keeps showing the previous image until it loads.
- The image is fetched once, even when it can't be cached.

Runs in React, Vue and web components.
