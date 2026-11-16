import { Field } from "ember-ui-sdk/field"
import { Switch } from "ember-ui-sdk/switch"

const settings = [
  {
    label: "Public profile",
    description: "Anyone can see your name and photo.",
    defaultChecked: false,
  },
  {
    label: "Show activity status",
    description: "Teammates can see when you're online.",
    defaultChecked: true,
  },
]

<template>
  <div data-slot="stack">
    {{#each settings key="label" as |setting|}}
      <Field data-variant="card" as |f|>
        <div data-slot="stack">
          <f.Label>{{setting.label}}</f.Label>
          <f.Description>{{setting.description}}</f.Description>
        </div>
        <Switch
          @defaultChecked={{setting.defaultChecked}}
          @field={{f.field}}
          as |s|
        >
          <s.Thumb />
        </Switch>
      </Field>
    {{/each}}
  </div>
</template>
