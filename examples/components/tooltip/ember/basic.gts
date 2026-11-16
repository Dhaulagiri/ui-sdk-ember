import { Bookmark } from "lucide"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "../../../shared/ember/icon"

<template>
  <Tooltip @defaultOpen={{true}} as |t|>
    <t.Trigger aria-label="Add to library">{{icon Bookmark}}</t.Trigger>
    <t.Content>Add to library</t.Content>
  </Tooltip>
</template>
