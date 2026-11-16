import { Checkbox } from "ember-ui-sdk/checkbox"
import { Check, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"

const topics = [
  { value: "design", label: "Design", checked: true },
  { value: "engineering", label: "Engineering", checked: false },
  { value: "marketing", label: "Marketing", checked: false },
  { value: "sales", label: "Sales", checked: false },
]

<template>
  <fieldset>
    <legend>Topics you follow</legend>
    <div data-slot="row">
      {{#each topics key="value" as |topic|}}
        <Checkbox
          @name="topics"
          @value={{topic.value}}
          @defaultChecked={{topic.checked}}
          @render={{true}}
          as |c|
        >
          <button {{c.part}}>
            {{#if c.state.checked}}
              {{icon Check}}
            {{else}}
              {{icon Plus}}
            {{/if}}
            {{topic.label}}
          </button>
        </Checkbox>
      {{/each}}
    </div>
  </fieldset>
</template>
