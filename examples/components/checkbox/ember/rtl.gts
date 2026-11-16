import { Checkbox } from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <div data-slot="stack" dir="rtl">
    <label data-slot="label">
      <Checkbox as |c|>
        <c.Indicator>{{icon Check}}</c.Indicator>
      </Checkbox>
      قبول الشروط والأحكام
    </label>
    <label data-slot="label">
      <Checkbox @defaultChecked={{true}} as |c|>
        <c.Indicator>{{icon Check}}</c.Indicator>
      </Checkbox>
      تفعيل الإشعارات
    </label>
  </div>
</template>
