import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Start date</f.Label>
    <DateInput @defaultValue="2026-11-02" @field={{f.field}} as |d|>
      {{#each d.state.segments key="key" as |segment|}}
        {{#if segment.editable}}
          <d.Segment @segment={{segment}} />
        {{else}}
          <d.Segment @segment={{segment}}>–</d.Segment>
        {{/if}}
      {{/each}}
    </DateInput>
  </Field>
</template>
