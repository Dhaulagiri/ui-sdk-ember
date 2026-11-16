import { Switch } from "ember-ui-sdk/switch"

<template>
  <label data-slot="label">
    Airplane mode
    <Switch as |s|>
      <s.Thumb />
    </Switch>
  </label>
</template>
