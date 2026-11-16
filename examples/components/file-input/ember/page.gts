import { File, Upload, X } from "lucide"
import { FileInput, formatFileSize } from "ember-ui-sdk/file-input"
import { icon } from "../../../shared/ember/icon"

<template>
  <FileInput @multiple={{true}} as |i|>
    <div data-slot="row">
      <p data-slot="hint">Drop files anywhere.</p>
      <i.Trigger>Upload Files</i.Trigger>
    </div>
    <i.Dropzone @target="document" data-variant="overlay">
      <div data-slot="stack">
        {{icon Upload}}
        <p>Drop to attach</p>
      </div>
    </i.Dropzone>
    <i.List aria-label="Attachments" as |list file row|>
      <row.Item as |item|>
        {{icon File}}
        <span>{{item.state.file.name}}</span>
        <span data-slot="hint">{{formatFileSize item.state.file.size}}</span>
        <item.Remove>{{icon X}}</item.Remove>
      </row.Item>
    </i.List>
  </FileInput>
</template>
