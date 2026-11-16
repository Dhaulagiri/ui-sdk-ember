import { Check, ChevronDown } from "lucide"
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

const variants = ["disabled", "readOnly", "item"]

const defaultValueOf = (variant: string) => (variant === "item" ? null : "fr")
const isDisabled = (variant: string) => variant === "disabled"
const isReadOnly = (variant: string) => variant === "readOnly"
const labelOf = (variant: string) =>
  variant === "disabled"
    ? "Billing country"
    : variant === "readOnly"
      ? "Shipping from"
      : "Shipping to"
const isUnavailable = (value: string) => value === "dk"

<template>
  <div data-slot="stack">
    {{#each variants key="@identity" as |variant|}}
      <Combobox
        @defaultValue={{defaultValueOf variant}}
        @itemToLabel={{countryLabel}}
        @disabled={{isDisabled variant}}
        @readOnly={{isReadOnly variant}}
        as |c|
      >
        <div data-slot="stack">
          <c.Label>{{labelOf variant}}</c.Label>
          <div data-slot="row">
            <c.Input placeholder="Search countries…" />
            <c.Trigger aria-label="Show countries">{{icon
                ChevronDown
              }}</c.Trigger>
          </div>
        </div>
        <c.Content>
          <c.Empty>No countries found.</c.Empty>
          <c.List>
            {{#each countries key="value" as |country|}}
              <c.Item
                @value={{country.value}}
                @label={{country.label}}
                @disabled={{isUnavailable country.value}}
                as |item|
              >
                {{country.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Combobox>
    {{/each}}
  </div>
</template>
