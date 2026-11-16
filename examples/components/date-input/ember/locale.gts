import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <div data-slot="stack">
    <Field as |f|>
      <f.Label>Date (en-GB)</f.Label>
      <DateInput
        @locale="en-GB"
        @defaultValue="2026-11-02"
        @field={{f.field}}
      />
    </Field>
    <Field as |f|>
      <f.Label>Datum (de-DE)</f.Label>
      <DateInput
        @locale="de-DE"
        @defaultValue="2026-11-02"
        @field={{f.field}}
      />
    </Field>
    <Field as |f|>
      <f.Label>日付 (ja-JP)</f.Label>
      <DateInput
        @locale="ja-JP"
        @defaultValue="2026-11-02"
        @field={{f.field}}
      />
    </Field>
  </div>
</template>
