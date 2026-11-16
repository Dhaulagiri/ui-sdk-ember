import { Toggle } from "ember-ui-sdk/toggle"
import { Bookmark } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <div dir="rtl">
    <Toggle as |t|>
      <t.Icon data-variant="fill">{{icon Bookmark}}</t.Icon>
      إشارة مرجعية
    </Toggle>
  </div>
</template>
