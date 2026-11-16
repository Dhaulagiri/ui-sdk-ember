import { Field } from "ember-ui-sdk/field"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"

<template>
  <Field as |f|>
    <f.Label>View</f.Label>
    <SegmentedControl @defaultValue="list" @field={{f.field}} as |s|>
      <s.Indicator />
      <s.Item @value="list">List</s.Item>
      <s.Item @value="grid">Grid</s.Item>
      <s.Item @value="board">Board</s.Item>
    </SegmentedControl>
  </Field>
</template>
