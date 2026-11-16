import { Check, ChevronDown, Minus } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const regions = [
  { value: "us-east", label: "US East" },
  { value: "us-west", label: "US West" },
  { value: "europe", label: "Europe" },
  { value: "asia-pacific", label: "Asia Pacific" },
  { value: "south-america", label: "South America" },
]

const defaultValue = ["us-east", "europe", "asia-pacific"]

const getMoreLabel = (count: number) => `${count} more`

<template>
  <Field as |f|>
    <f.Label>Regions</f.Label>
    <Select
      @multiple={{true}}
      @defaultValue={{defaultValue}}
      @placeholder="Select regions"
      as |s|
    >
      <s.Trigger @field={{f.field}}>
        <s.Value @maxLabels={{2}} @getMoreLabel={{getMoreLabel}} />
        {{icon ChevronDown}}
      </s.Trigger>
      <s.Content>
        <s.SelectAll as |all|>
          Select all
          {{#if all.state.checked}}
            {{icon Check}}
          {{/if}}
          {{#if all.state.indeterminate}}
            {{icon Minus}}
          {{/if}}
        </s.SelectAll>
        <s.Separator />
        {{#each regions key="value" as |region|}}
          <s.Item @value={{region.value}} as |item|>
            {{region.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </s.Item>
        {{/each}}
      </s.Content>
    </Select>
  </Field>
</template>
