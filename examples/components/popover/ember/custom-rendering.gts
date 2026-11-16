import { Popover } from "ember-ui-sdk/popover"

<template>
  <Popover as |p|>
    <p.Trigger @shortcut="mod+u" @render={{true}} as |trigger|>
      <button type="button" {{trigger.part}}>
        {{if trigger.state.open "Hide Updates" "Show Updates"}}
        <p.Shortcut as |shortcut|>{{shortcut.state.text}}</p.Shortcut>
      </button>
    </p.Trigger>
    <p.Content>
      <p.Title @render={{true}} as |title|>
        <h3 {{title.part}}>Updates</h3>
      </p.Title>
      <p.Description>Version 2.4 adds threaded comments.</p.Description>
      <p.Close @render={{true}} as |close|>
        <a href="#" {{close.part}}>Read the Changelog</a>
      </p.Close>
    </p.Content>
  </Popover>
</template>
