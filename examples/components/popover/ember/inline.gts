import { Popover } from "ember-ui-sdk/popover"

<template>
  <div data-slot="popover-frame">
    <div data-slot="popover-corner">
      <Popover as |p|>
        <p.Trigger>Feedback</p.Trigger>
        <p.Content @inline={{true}}>
          <p.Title>Send feedback</p.Title>
          <p.Description>The panel sits in the corner box, above its trigger.</p.Description>
          <div data-slot="row">
            <p.Close>Close</p.Close>
          </div>
        </p.Content>
      </Popover>
    </div>
  </div>
</template>
