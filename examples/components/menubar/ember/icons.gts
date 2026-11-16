import {
  CircleHelp,
  File,
  Folder,
  Redo,
  Save,
  Settings,
  Trash,
  Undo,
} from "lucide"
import { Menubar } from "ember-ui-sdk/menubar"
import { icon } from "../../../shared/ember/icon"

<template>
  <Menubar as |mb|>
    <mb.Menu as |m|>
      <m.Trigger>File</m.Trigger>
      <m.Content>
        <m.Item>
          <m.ItemIcon>{{icon File}}</m.ItemIcon>
          New File
        </m.Item>
        <m.Item>
          <m.ItemIcon>{{icon Folder}}</m.ItemIcon>
          Open Folder
        </m.Item>
        <m.Item>
          <m.ItemIcon>{{icon Save}}</m.ItemIcon>
          Save
        </m.Item>
      </m.Content>
    </mb.Menu>
    <mb.Menu as |m|>
      <m.Trigger>Edit</m.Trigger>
      <m.Content>
        <m.Item>
          <m.ItemIcon @mirror={{true}}>{{icon Undo}}</m.ItemIcon>
          Undo
        </m.Item>
        <m.Item>
          <m.ItemIcon @mirror={{true}}>{{icon Redo}}</m.ItemIcon>
          Redo
        </m.Item>
      </m.Content>
    </mb.Menu>
    <mb.Menu as |m|>
      <m.Trigger>More</m.Trigger>
      <m.Content>
        <m.Item>
          <m.ItemIcon>{{icon Settings}}</m.ItemIcon>
          Settings
        </m.Item>
        <m.Item>
          <m.ItemIcon>{{icon CircleHelp}}</m.ItemIcon>
          Help
        </m.Item>
        <m.Separator />
        <m.Item @destructive={{true}}>
          <m.ItemIcon>{{icon Trash}}</m.ItemIcon>
          Delete
        </m.Item>
      </m.Content>
    </mb.Menu>
  </Menubar>
</template>
