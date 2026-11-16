import {
  Check,
  ChevronDown,
  TextAlignCenter,
  TextAlignEnd,
  TextAlignStart,
} from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field as |f|>
    <f.Label>Text alignment</f.Label>
    <Select @defaultValue="start" as |s|>
      <s.Trigger @field={{f.field}}>
        <s.ValueIcon />
        <s.Value />
        {{icon ChevronDown}}
      </s.Trigger>
      <s.Content>
        <s.Item @value="start" as |item|>
          <item.Icon @mirror={{true}}>{{icon TextAlignStart}}</item.Icon>
          Start
          <item.Indicator>{{icon Check}}</item.Indicator>
        </s.Item>
        <s.Item @value="center" as |item|>
          <item.Icon>{{icon TextAlignCenter}}</item.Icon>
          Center
          <item.Indicator>{{icon Check}}</item.Indicator>
        </s.Item>
        <s.Item @value="end" as |item|>
          <item.Icon @mirror={{true}}>{{icon TextAlignEnd}}</item.Icon>
          End
          <item.Indicator>{{icon Check}}</item.Indicator>
        </s.Item>
      </s.Content>
    </Select>
  </Field>
</template>
