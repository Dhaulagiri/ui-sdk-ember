import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const speeds = [
  { value: "standard", label: "عادي" },
  { value: "express", label: "سريع" },
  { value: "overnight", label: "خلال ليلة" },
]

<template>
  <div dir="rtl">
    <Field as |f|>
      <f.Label>سرعة الشحن</f.Label>
      <RadioGroup @defaultValue="express" @field={{f.field}} as |g|>
        {{#each speeds key="value" as |speed|}}
          <label data-slot="label">
            <g.Radio @value={{speed.value}} as |r|>
              <r.Indicator />
            </g.Radio>
            {{speed.label}}
          </label>
        {{/each}}
      </RadioGroup>
    </Field>
  </div>
</template>
