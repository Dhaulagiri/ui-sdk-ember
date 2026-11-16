import { Switch } from "ember-ui-sdk/switch"
import { Moon, Sun } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <label data-slot="label">
    Dark mode
    <Switch as |s|>
      <s.Thumb @render={{true}} as |t|>
        <span {{t.part}}>
          {{#if t.state.checked}}{{icon Moon}}{{else}}{{icon Sun}}{{/if}}
        </span>
      </s.Thumb>
    </Switch>
  </label>
</template>
