import { Checkbox } from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

const tasks = [
  { label: "Write the release notes", done: false },
  { label: "Update the changelog", done: true },
  { label: "Tag the release", done: false },
]

<template>
  <div data-slot="stack">
    {{#each tasks key="label" as |task|}}
      <label data-slot="label">
        <Checkbox @defaultChecked={{task.done}} as |c|>
          <c.Indicator>{{icon Check}}</c.Indicator>
        </Checkbox>
        {{task.label}}
      </label>
    {{/each}}
  </div>
</template>
