import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { selectFixture as f } from "tests/fixtures/select.ts"

<template>
  <div class="fixture">
    <button>Before</button>
    <form class="select-form" aria-label={{f.formLabel}}>
      <Field @name={{f.name}} as |field|>
        <field.Label class="label">{{f.label}}</field.Label>
        <Select @field={{field.field}} @placeholder={{f.placeholder}} as |s|>
          <s.Trigger class="trigger" as |trigger|><trigger.Value
              class="value"
            /></s.Trigger>
          <s.Content class="popup list-popup">
            <s.List>
              {{#each f.items key="value" as |item|}}
                <s.Item
                  class="item"
                  @value={{item.value}}
                  @label={{item.label}}
                  as |i|
                >
                  <i.Text @render={{true}} as |t|><span
                      class="item-text"
                      {{t.part}}
                    >{{item.label}}</span></i.Text>
                </s.Item>
              {{/each}}
            </s.List>
          </s.Content>
        </Select>
      </Field>
    </form>
    <button>After</button>
  </div>
</template>
