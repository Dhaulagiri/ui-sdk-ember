---
title: Image Cropper
description: Choose the part of an image to keep by moving and resizing a selection, or by panning and zooming the image under it.
---

Use an image cropper to choose the part of a photo to keep, like a profile picture or a cover image. The crop is a box in the image's own pixels, with a quarter-turn rotation and a flip, ready to pass to [`cropImage`](https://ui-sdk.dev/docs/core/image).

[image-cropper/basic](../../examples/components/image-cropper/ember/basic.gts)

Pick a ratio, drag the selection or one of its handles, then press Crop. Tab to the selection and use the arrow keys, with Shift to move further.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build an `ImageCropper`:

```text
ImageCropper as |c|
├── c.Viewport as |v|
│   ├── c.Image
│   └── c.Selection as |s|
│       ├── c.Grid
│       └── c.Handle
├── c.Zoom
├── c.Rotate
└── c.Flip
```

- **ImageCropper** holds the crop and the image's `@src`, and is a group around the parts.
- **c.Viewport** is the area the image shows in. Give it a size, and its padding keeps the image off its edges.
- **c.Image** is the image, turned and flipped. Give it `alt`.
- **c.Selection** shows the crop over the image. It's a slider you drag or move with the arrow keys.
- **c.Grid** draws lines across the selection, in thirds, for you to style.
- **c.Handle** resizes the selection from one edge or corner, its `@position`, like `"se"` for the bottom right.
- **c.Zoom** is a range input from 1, the largest crop, to `@maxZoom`.
- **c.Rotate** turns the image a quarter clockwise.
- **c.Flip** mirrors the image left to right, or top to bottom with `@direction="vertical"`.

The viewport, image and selection are needed. The rest are optional.

## Usage

Import the root and use the parts it yields:

```gts
import { ImageCropper } from "ember-ui-sdk/image-cropper"

<template>
  <ImageCropper
    @src={{this.src}}
    @aspectRatio={{3}}
    aria-label="Cover photo"
    as |c|
  >
    <c.Viewport as |v|>
      <c.Image alt="Your cover photo" />
      <c.Selection as |s|>
        <c.Handle @position="nw" />
        <c.Handle @position="se" />
      </c.Selection>
    </c.Viewport>
  </ImageCropper>
</template>
```

Name the cropper with `aria-label`. Until the image loads, the root has `data-loading` and `aria-busy`, and the selection is hidden. The crop then starts in the middle at `@aspectRatio`, four fifths as large as the image allows so its edges show, or as large as it allows in a frame, unless you pass `@defaultCrop`:

```gts
<ImageCropper
  @src={{this.src}}
  @defaultCrop={{hash x=40 y=40 width=320 height=240}}
  aria-label="Photo"
  as |c|
>…</ImageCropper>
```

## Aspect Ratio

Set `@aspectRatio` to keep the crop's width over its height, like `1` for a square or `16 / 9`. Changing it fits the crop to the new ratio about its middle. Without one, the crop is free, and holding Shift while dragging a handle keeps its current ratio. `@minWidth` and `@minHeight` stop it getting too small, in image pixels.

[image-cropper/aspect-ratio](../../examples/components/image-cropper/ember/aspect-ratio.gts)

Choose Square or Wide, then drag an edge. Flip mirrors the image and the crop with it.

## Frame Mode

Set `@mode="frame"` for an avatar editor. The selection stays still and as large as it fits, and you pan the image under it with a drag, and zoom with the wheel, a pinch or the zoom input. Handles don't show in a frame.

`@shape="circle"` rounds the selection, but the crop is still its box, so pass `shape: "circle"` to `cropImage` too. Here, Save Avatar crops a 128 pixel round file:

[image-cropper/avatar](../../examples/components/image-cropper/ember/avatar.gts)

Drag the image or move the zoom, then press Save Avatar. The new avatar shows beside the button.

## Rotate and Flip

`c.Rotate` turns the image a quarter clockwise, and R does the same from the keyboard, with Shift to turn it back. `c.Flip` mirrors the image. The crop turns and flips with the image, so it keeps the same part of the photo. Its `x` and `y` count from the top left of the image as it shows, turned and flipped, which is what `cropImage` takes.

## Disabled

Set `@disabled={{true}}`. The selection and handles can't be focused or dragged, and the zoom input and buttons are disabled.

```gts
<ImageCropper @src={{this.src}} @disabled={{true}} aria-label="Photo" as |c|>…</ImageCropper>
```

## Controlled

Pass `@crop` and update it in `@onCropChange`, which also receives the details. Each change carries a [reason](https://ui-sdk.dev/docs/react/components/image-cropper#reasons), like `drag`, `step-key` or `zoom-input`. Call `details.cancel()` in the callback to keep the current crop.

`@onCropChange` runs on every step of a drag and once the image loads. `@onCropCommit` runs once, when the drag, key press or wheel ends, so use it to save. A controller from `createImageCropperController()` sets the crop from anywhere:

```gts
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import {
  ImageCropper,
  createImageCropperController,
} from "ember-ui-sdk/image-cropper"

export default class Photo extends Component {
  controller = createImageCropperController()

  zoomIn = () => this.controller.setZoom(2)
  saveCrop = () => {}

  <template>
    <ImageCropper
      @src="/photo.jpg"
      @controller={{this.controller}}
      @onCropCommit={{this.saveCrop}}
      aria-label="Photo"
      as |c|
    >…</ImageCropper>
    <button type="button" {{on "click" this.zoomIn}}>Zoom In</button>
  </template>
}
```

## Custom Rendering

Pass `@render={{true}}` to a part to render it as your own element. It yields `{ part, state }`: bind `part` to your element as a modifier, and read the state in the block. Every part has the `crop`, the `zoom`, and whether it's `loading`, has an `error` or is `dragging`.

See [State](https://ui-sdk.dev/docs/react/components/image-cropper#state) for each part's fields.

## Styling

Parts are unstyled, apart from the positions they need: the viewport is `position: relative` with `overflow: hidden`, and the image and selection get their place as inline styles in pixels. Give the viewport a size, and the handles a size and a place on their edge or corner of the selection.

A box viewport fits the whole image, so set its `aspect-ratio` to `--image-cropper-aspect-ratio`. A wide `box-shadow` on the selection dims the image outside it. Show the grid only while `data-dragging` is on it.

Each part has a `data-slot`, such as `image-cropper-selection`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/image-cropper#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [image-cropper reference](https://ui-sdk.dev/docs/react/components/image-cropper) in the upstream docs.

Pass the root's options as `@` arguments. `@crop` is controlled with `@onCropChange`.

### Controller

Create one with `createImageCropperController()` and pass it as `@controller`.

Each write method takes an optional `{ reason, event }`, runs the change callback like a drag, and returns `false` when nothing changed or the change is canceled.

### Events

Callbacks get the new crop first, then the details. A controlled `@crop` only updates when `@onCropChange` wasn't canceled.

| Argument        | On             | Receives                                                                                                         |
| --------------- | -------------- | ---------------------------------------------------------------------------------------------------------------- |
| `@onCropChange` | `ImageCropper` | `(crop, details)`: the new crop and the [reason](https://ui-sdk.dev/docs/react/components/image-cropper#reasons) |
| `@onCropCommit` | `ImageCropper` | `(crop, details)`: the crop once the interaction ends, its reason                                                |

## Accessibility

No WAI-ARIA pattern covers an image cropper, so it's built from ones that do. The cropper is a group. The selection and each handle follow the [WAI-ARIA slider pattern](https://www.w3.org/WAI/ARIA/apg/patterns/slider/), and say the crop in words, like "300 by 300 pixels, at 50, 0". The zoom is a native range input that says its level, like "125%".

The selection, handles and zoom are named in English by default. Pass `aria-label` to name them in another language.

### Keyboard

| Key                 | Does                                                     |
| ------------------- | -------------------------------------------------------- |
| Arrow keys          | Move the selection, or on a handle, move its edges       |
| Shift with an arrow | Moves ten times as far                                   |
| Plus or Minus       | Zooms in or out, about the crop's middle                 |
| R                   | Turns the image a quarter clockwise, or back with Shift  |
| Escape              | During a drag, puts the crop back where the drag started |

Each key press commits, like the end of a drag.
