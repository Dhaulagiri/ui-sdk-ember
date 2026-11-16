import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"

<template>
  <div data-slot="row">
    <Popover as |p|>
      <p.Trigger>Rename</p.Trigger>
      <p.Content>
        <p.Title>Rename file</p.Title>
        <p.Description>Focus starts in the first field.</p.Description>
        <Field as |f|>
          <f.Label>Name</f.Label>
          <Input @field={{f.field}} @defaultValue="Q3 roadmap.pdf" />
        </Field>
        <div data-slot="row">
          <p.Close>Cancel</p.Close>
          <p.Close data-variant="solid">Save</p.Close>
        </div>
      </p.Content>
    </Popover>
    <Popover as |p|>
      <p.Trigger>Publish</p.Trigger>
      <p.Content @initialFocus="[data-autofocus]">
        <p.Title>Publish changes?</p.Title>
        <p.Description>Focus starts on Publish, not Cancel.</p.Description>
        <div data-slot="row">
          <p.Close>Cancel</p.Close>
          <p.Close data-autofocus="" data-variant="solid">Publish</p.Close>
        </div>
      </p.Content>
    </Popover>
    <Popover as |p|>
      <p.Trigger>Status</p.Trigger>
      <p.Content @initialFocus="none" @finalFocus="none">
        <p.Title>All systems normal</p.Title>
        <p.Description>Focus stays on the trigger.</p.Description>
      </p.Content>
    </Popover>
  </div>
</template>
