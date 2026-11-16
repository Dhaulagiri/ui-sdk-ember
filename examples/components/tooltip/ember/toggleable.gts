import { Info } from "lucide"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "../../../shared/ember/icon"

<template>
  <div data-slot="row">
    <span data-slot="label">Storage</span>
    <Tooltip @toggleable={{true}} as |t|>
      <t.Trigger aria-label="About storage" data-size="sm">{{icon
          Info
        }}</t.Trigger>
      <t.Content>Files in the trash still use storage.</t.Content>
    </Tooltip>
    <span data-slot="hint">12.4 of 15 GB used</span>
  </div>
</template>
