import { Label } from "ember-ui-sdk/label"
import { RadioGroup } from "ember-ui-sdk/radio"

const speeds = [
  { value: "standard", label: "Standard" },
  { value: "express", label: "Express" },
  { value: "overnight", label: "Overnight" },
]

<template>
  <div data-slot="stack">
    <Label for="shipping-speed">Shipping speed</Label>
    <RadioGroup id="shipping-speed" @defaultValue="standard" as |g|>
      {{#each speeds key="value" as |speed|}}
        <Label>
          <g.Radio @value={{speed.value}} as |r|>
            <r.Indicator />
          </g.Radio>
          {{speed.label}}
        </Label>
      {{/each}}
    </RadioGroup>
  </div>
</template>
