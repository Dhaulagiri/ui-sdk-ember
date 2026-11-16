import { Switch } from "ember-ui-sdk/switch"

<template>
  <div data-slot="stack">
    <label data-slot="label">
      Product updates
      <Switch as |s|>
        <s.Thumb />
      </Switch>
    </label>
    <label data-slot="label">
      Security alerts
      <Switch @defaultChecked={{true}} @disabled={{true}} as |s|>
        <s.Thumb />
      </Switch>
    </label>
  </div>
</template>
