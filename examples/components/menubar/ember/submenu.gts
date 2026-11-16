import { ChevronRight } from "lucide"
import { Menubar } from "ember-ui-sdk/menubar"
import { icon } from "../../../shared/ember/icon"

<template>
  <Menubar as |mb|>
    <mb.Menu as |m|>
      <m.Trigger>File</m.Trigger>
      <m.Content>
        <m.Item>New File</m.Item>
        <m.Sub as |s|>
          <s.Trigger>
            Share
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Item>Email link</s.Item>
            <s.Item>Messages</s.Item>
          </s.Content>
        </m.Sub>
      </m.Content>
    </mb.Menu>
    <mb.Menu as |m|>
      <m.Trigger>Edit</m.Trigger>
      <m.Content>
        <m.Item>Undo</m.Item>
        <m.Sub as |s|>
          <s.Trigger>
            Find
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Item>Find…</s.Item>
            <s.Item>Find Next</s.Item>
          </s.Content>
        </m.Sub>
      </m.Content>
    </mb.Menu>
  </Menubar>
</template>
