import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

const options = [
  {
    value: "all",
    label: "Everything",
    description: "Every message and update.",
  },
  {
    value: "mentions",
    label: "Mentions",
    description: "Only when someone mentions you.",
  },
  { value: "none", label: "Nothing", description: "Turn notifications off." },
]

<template>
  <Field as |f|>
    <f.Label>Notify me about</f.Label>
    <RadioGroup @defaultValue="mentions" @field={{f.field}} as |g|>
      {{#each options key="value" as |option|}}
        <g.Radio
          @value={{option.value}}
          aria-labelledby="render-{{option.value}}-label"
          aria-describedby="render-{{option.value}}-description"
          @render={{true}}
          as |r|
        >
          <button {{r.part}}>
            <span data-slot="stack">
              <span id="render-{{option.value}}-label">{{option.label}}</span>
              <span
                data-slot="hint"
                id="render-{{option.value}}-description"
              >{{option.description}}</span>
            </span>
            <span data-checked={{if r.state.checked ""}}>{{icon Check}}</span>
          </button>
        </g.Radio>
      {{/each}}
    </RadioGroup>
  </Field>
</template>
