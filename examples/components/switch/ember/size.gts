import { Switch } from "ember-ui-sdk/switch"

<template>
  <div data-slot="stack">
    <label data-slot="label">
      Small
      <Switch data-size="sm" as |s|>
        <s.Thumb />
      </Switch>
    </label>
    <label data-slot="label">
      Default
      <Switch as |s|>
        <s.Thumb />
      </Switch>
    </label>
  </div>
</template>
