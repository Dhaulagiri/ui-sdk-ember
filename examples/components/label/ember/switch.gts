import { Label } from "ember-ui-sdk/label"
import { Switch } from "ember-ui-sdk/switch"

<template>
  <div data-slot="row">
    <Switch id="updates" as |s|>
      <s.Thumb />
    </Switch>
    <Label for="updates">Email me product updates</Label>
  </div>
</template>
