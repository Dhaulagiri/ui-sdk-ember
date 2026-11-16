---
title: File Input
description: Choose, drop, or paste files, validate them, and submit them with a form.
---

A file input holds the files someone chooses, drops, or pastes, checks them against your rules, and submits them with a form. Uploading them to a server is up to your app.

[file-input/basic](../../examples/components/file-input/ember/basic.gts)

Browse Files or drop a few files on the zone, then remove one. Tab to the list to move between files with the arrow keys, and press Delete to remove the focused one.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `FileInput`:

```text
FileInput as |i|
├── i.Trigger
├── i.Dropzone
└── i.List
    └── row.Item
        └── item.Remove
```

The trigger opens the system file picker. The drop zone takes files that are dropped on it or pasted while focus is inside it; keep a trigger beside it for people using a keyboard. The list renders its item once for each file, and an item's state has its `file` and `index`. A remove button removes its item's file.

## Usage

Import the root and use the parts it yields:

```gts
import { FileInput, formatFileSize } from "ember-ui-sdk/file-input"

<template>
  <FileInput @multiple={{true}} @name="attachments" as |i|>
    <i.Dropzone>
      <p>Drag and drop files here</p>
      <i.Trigger>Browse Files</i.Trigger>
    </i.Dropzone>
    <i.List aria-label="Files" as |list file row|>
      <row.Item as |item|>
        <span>{{item.state.file.name}}</span>
        <span>{{formatFileSize item.state.file.size}}</span>
        <item.Remove aria-label="Remove file">×</item.Remove>
      </row.Item>
    </i.List>
  </FileInput>
</template>
```

## Upload Button

A trigger is enough when you only need the system file picker. Read the chosen file from the root's state to show its name beside the button.

## Accepted Types

`@accept` takes MIME types, wildcards, and extensions, such as `image/*` and `.pdf`. It checks files from the picker, drops, and pastes. An extension matches the filename, even when the operating system reports an unexpected MIME type.

A rejected file never joins the value. `@onReject` receives each one with its `reasons`, such as `file-type`, so you can say why it was left out. While files are dragged over a drop zone, `data-drag-reject` shows when their types won't be accepted.

```gts
<FileInput @multiple={{true}} @accept={{array "image/*" ".pdf"}} @onReject={{this.onReject}} as |i|>…</FileInput>
```

## Limits

Use `@maxFiles` to limit the total count, and `@minSize` or `@maxSize` for bytes per file. When too many files arrive, the component accepts the first ones that pass the other checks until the list is full, and rejects the rest with `too-many-files`.

```gts
<FileInput @multiple={{true}} @maxFiles={{3}} @minSize={{1}} @maxSize={{5000000}} as |i|>…</FileInput>
```

## One File

Without `@multiple`, a new file replaces the current one. A rejected file leaves the current value unchanged. With `@multiple`, accepted files join the list.

## Validation

Pass `@validate` for checks of your own. Return a reason string to reject a file, or `null` to accept it. It runs after the built-in type and size checks, and its reason reaches `@onReject` like theirs. Validate uploads on your server too.

## Page-Wide Drop

Set `@target="document"` to take files dropped anywhere on the page. The zone shows `data-dragging` while a file is over the window, so it can be a full-page overlay. A drop on another zone stays with that zone.

[file-input/page](../../examples/components/file-input/ember/page.gts)

Drag a file over this page to see the overlay, then drop it. The file joins the Attachments list; a drop on the first example's zone stays there.

While a drop zone is mounted, dropping a file outside every zone doesn't navigate away from the page. Drops onto native file inputs and ordinary text drops keep their behavior.

## Folders

`@directory={{true}}` picks a whole folder and turns on `@multiple`. Dropped folders are read recursively, up to 1,000 files, skipping system files such as `.DS_Store`. `relativePath(file)` returns the path inside the folder.

## Camera

Use `@capture="environment"` to request the rear camera, or `"user"` for the front camera. The picker offered depends on the device and browser; a desktop browser opens a file picker.

```gts
<FileInput @accept="image/*" @capture="environment" as |i|>
  <i.Trigger>Take a Photo</i.Trigger>
</FileInput>
```

## Controlled

Pass `@value` and update it in `@onValueChange`. `details` has the `reason` and the `added`, `removed`, and `rejected` files. Call `details.cancel()` to keep the current value. `@onReject` reports rejected files even when none were accepted.

## Opening from Anywhere

Create a controller with `createFileInputController()` and pass it as `@controller`. Use it to open the picker, add or remove files, clear the value, or read the files. Open the picker from a user action, such as a button press, so the browser allows it.

## Announcements

The component announces accepted, removed, and rejected files through a polite live region. Pass `@announcement` to change the message, or return `null` to skip it.

## Forms

With `@name`, the component submits its files through a native file input. A form reset returns to `@defaultValue`. `@form` connects the file input to a form elsewhere on the page. Rejected files never submit, and `@disabled={{true}}` leaves the value out of the submission as well as stopping picks, drops, and pastes.

## Fields

Wrap the file input in a [Field](./field.md) to connect its label, description, and validation message. The trigger becomes the field's control, and pressing the label opens the picker. `@required={{true}}` stops the form from submitting with no file.

## Custom Rendering

Pass `@render={{true}}` to a part to render a different element in its place. It yields `{ part, state }`: bind `part` to your element as a modifier, and read the state in the block.

## Styling

Use `data-dragging`, `data-drag-accept`, and `data-drag-reject` on the drop zone to show what a drop would do. Drag acceptance reflects the file information the browser exposes before a drop. Inside a Field, the trigger also gets the field's attributes, such as `data-invalid`.

Each part has a `data-slot`, such as `file-input-dropzone`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/file-input#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [file-input reference](https://ui-sdk.dev/docs/react/components/file-input) in the upstream docs.

Pass the root's options as `@` arguments. `@value` is controlled with `@onValueChange`.

### FileInputList

Renders its block once for each file.

### FileInputItemRemove

Removes its item's file. It's named for the file and stays out of the Tab order.

### Controller

Create one with `createFileInputController()` and pass it as `@controller`.

## Accessibility

Keep a trigger available alongside a drop zone for people using a keyboard or screen reader. Changes are announced through a polite live region, and the file list supports keyboard navigation and removal.
