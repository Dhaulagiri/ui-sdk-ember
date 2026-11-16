import { Collapsible } from "ember-ui-sdk/collapsible"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const details = [
  { label: "عنوان الشحن", value: "شارع الملك فهد، الرياض" },
  { label: "المنتجات", value: "قميص كتان × ٢" },
  { label: "التوصيل", value: "عادي، يصل في ٧ مارس" },
  { label: "الإجمالي", value: "٨٤٫٠٠ $" },
]

<template>
  <div dir="rtl">
    <Collapsible as |c|>
      <div data-slot="row">
        <div data-slot="stack">
          <p>الطلب #4189</p>
          <p data-slot="hint">تم الطلب في ٣ مارس</p>
        </div>
        <span data-slot="row"> تم الشحن </span>
      </div>
      <div>
        <c.Trigger data-variant="ghost">
          تفاصيل الطلب
          {{icon ChevronDown}}
        </c.Trigger>
        <c.Panel>
          <dl>
            {{#each details key="label" as |detail|}}
              <div data-slot="row">
                <dt>{{detail.label}}</dt>
                <dd>{{detail.value}}</dd>
              </div>
            {{/each}}
          </dl>
        </c.Panel>
      </div>
    </Collapsible>
  </div>
</template>
