import { ToggleGroup } from "ember-ui-sdk/toggle"
import { Bold, Italic, Underline } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <ToggleGroup @multiple={{true}} aria-label="Text formatting" as |g|>
    <g.Toggle @value="bold" aria-label="Bold" as |t|>
      <t.Icon>{{icon Bold}}</t.Icon>
    </g.Toggle>
    <g.Toggle @value="italic" aria-label="Italic" as |t|>
      <t.Icon>{{icon Italic}}</t.Icon>
    </g.Toggle>
    <g.Toggle @value="underline" aria-label="Underline" as |t|>
      <t.Icon>{{icon Underline}}</t.Icon>
    </g.Toggle>
  </ToggleGroup>
</template>
