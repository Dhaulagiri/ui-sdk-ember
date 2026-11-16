import { Checkbox } from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <div data-slot="stack">
    <label data-slot="label">
      <Checkbox @defaultChecked={{true}} as |c|>
        <c.Indicator>{{icon Check}}</c.Indicator>
      </Checkbox>
      Product updates
    </label>
    <label data-slot="label">
      <Checkbox @defaultChecked={{true}} @disabled={{true}} as |c|>
        <c.Indicator>{{icon Check}}</c.Indicator>
      </Checkbox>
      Security alerts
    </label>
  </div>
</template>
