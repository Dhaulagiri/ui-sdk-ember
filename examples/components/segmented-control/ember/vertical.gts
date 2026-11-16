import { Field } from "ember-ui-sdk/field"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"

<template>
  <Field as |f|>
    <f.Label>Vertical alignment</f.Label>
    <SegmentedControl
      @orientation="vertical"
      @defaultValue="middle"
      @field={{f.field}}
      as |s|
    >
      <s.Indicator />
      <s.Item @value="top">Top</s.Item>
      <s.Item @value="middle">Middle</s.Item>
      <s.Item @value="bottom">Bottom</s.Item>
    </SegmentedControl>
  </Field>
</template>
