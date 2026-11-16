import { NumberInput } from "ember-ui-sdk/number-input"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Toolbar aria-label="Text" as |t|>
    <NumberInput @defaultValue={{14}} @min={{8}} @max={{72}} as |n|>
      <n.Group>
        <n.Decrement aria-label="Decrease font size">
          {{icon Minus}}
        </n.Decrement>
        <t.Input @render={{true}} as |field|>
          <n.Control @render={{true}} as |control|>
            <input {{control.part}} {{field.part}} aria-label="Font size" />
          </n.Control>
        </t.Input>
        <n.Increment aria-label="Increase font size">
          {{icon Plus}}
        </n.Increment>
      </n.Group>
    </NumberInput>
    <t.Separator />
    <t.Input aria-label="Find" placeholder="Find…" />
  </Toolbar>
</template>
