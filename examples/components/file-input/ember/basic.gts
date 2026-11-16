import { File, Upload, X } from "lucide"
import { FileInput, formatFileSize } from "ember-ui-sdk/file-input"
import { icon } from "../../../shared/ember/icon"

<template>
  <FileInput @multiple={{true}} as |i|>
    <i.Dropzone>
      {{icon Upload}}
      <p>Drag and drop files here</p>
      <p data-slot="hint">Or paste them from your clipboard.</p>
      <i.Trigger>Browse Files</i.Trigger>
    </i.Dropzone>
    <i.List aria-label="Files" as |list file row|>
      <row.Item as |item|>
        {{icon File}}
        <span>{{item.state.file.name}}</span>
        <span data-slot="hint">{{formatFileSize item.state.file.size}}</span>
        <item.Remove>{{icon X}}</item.Remove>
      </row.Item>
    </i.List>
  </FileInput>
</template>
