import { Toolbar } from "ember-ui-sdk/toolbar"
import { Bold, Italic, Link } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <div dir="rtl">
    <Toolbar aria-label="تنسيق" as |t|>
      <t.Toggle aria-label="غامق" as |p|>
        <p.Icon>{{icon Bold}}</p.Icon>
      </t.Toggle>
      <t.Toggle aria-label="مائل" as |p|>
        <p.Icon>{{icon Italic}}</p.Icon>
      </t.Toggle>
      <t.Separator />
      <t.Button aria-label="إدراج رابط">{{icon Link}}</t.Button>
    </Toolbar>
  </div>
</template>
