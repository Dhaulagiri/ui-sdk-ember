import { array } from "@ember/helper"
import { ToggleGroup } from "ember-ui-sdk/toggle"
import { TextAlignCenter, TextAlignEnd, TextAlignStart } from "lucide"
import { icon } from "../../../shared/ember/icon"

const alignments = [
  { value: "start", label: "Align start", icon: TextAlignStart, mirror: true },
  {
    value: "center",
    label: "Align center",
    icon: TextAlignCenter,
    mirror: false,
  },
  { value: "end", label: "Align end", icon: TextAlignEnd, mirror: true },
]

<template>
  <ToggleGroup
    @defaultValue={{array "start"}}
    @deselectable={{false}}
    aria-label="Text alignment"
    as |g|
  >
    {{#each alignments key="value" as |item|}}
      <g.Toggle @value={{item.value}} aria-label={{item.label}} as |t|>
        <t.Icon @mirror={{item.mirror}}>{{icon item.icon}}</t.Icon>
      </g.Toggle>
    {{/each}}
  </ToggleGroup>
</template>
