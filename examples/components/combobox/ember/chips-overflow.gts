import { array, concat, get } from "@ember/helper"
import { Check, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

const countries = [
  { value: "ar", label: "Argentina" },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria" },
  { value: "be", label: "Belgium" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark" },
  { value: "fi", label: "Finland" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "gr", label: "Greece" },
  { value: "jp", label: "Japan" },
  { value: "nl", label: "Netherlands" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
  { value: "ch", label: "Switzerland" },
]

const countryLabel = (value: string) =>
  countries.find((country) => country.value === value)?.label ?? value

const joinLabels = (labels: string[]) => labels.join(", ")

<template>
  <Combobox
    @multiple={{true}}
    @defaultValue={{array "fr" "jp" "se" "de" "ch"}}
    @itemToLabel={{countryLabel}}
    as |c|
  >
    <div data-slot="stack">
      <c.Label>Countries</c.Label>
      <c.Chips>
        <c.Value as |state|>
          {{#each state.value key="@identity" as |value index|}}
            <c.Chip @value={{value}} as |chip|>
              {{get state.labels index}}
              <chip.Remove
                aria-label={{concat "Remove " (get state.labels index)}}
              >{{icon X}}</chip.Remove>
            </c.Chip>
          {{/each}}
        </c.Value>
        <c.ChipsOverflow @render={{true}} as |o|>
          <span {{o.part}} title={{joinLabels o.state.labels}} data-slot="hint">
            +{{o.state.count}}
          </span>
        </c.ChipsOverflow>
        <c.Input placeholder="Add…" />
      </c.Chips>
      <p data-slot="hint">
        <c.Value @maxLabels={{2}} />
      </p>
    </div>
    <c.Content>
      <c.Empty>No countries found.</c.Empty>
      <c.List>
        {{#each countries key="value" as |country|}}
          <c.Item @value={{country.value}} @label={{country.label}} as |item|>
            {{country.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
