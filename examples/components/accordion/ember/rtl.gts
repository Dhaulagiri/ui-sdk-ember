import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const items = [
  {
    value: "shipping",
    label: "ما هي خيارات الشحن؟",
    content: "نقدم الشحن العادي والسريع والشحن في اليوم التالي.",
  },
  {
    value: "returns",
    label: "ما هي سياسة الإرجاع؟",
    content: "يمكنك إرجاع أي منتج غير مستخدم خلال ٣٠ يومًا.",
  },
  {
    value: "support",
    label: "كيف أتواصل مع الدعم؟",
    content: "راسلنا عبر البريد أو الدردشة، ونرد خلال ٢٤ ساعة.",
  },
]

<template>
  <div dir="rtl">
    <Accordion @defaultValue={{array "shipping"}} as |a|>
      {{#each items key="value" as |item|}}
        <a.Item @value={{item.value}} as |i|>
          <i.Header>
            <i.Trigger>
              {{item.label}}
              {{icon ChevronDown}}
            </i.Trigger>
          </i.Header>
          <i.Panel>{{item.content}}</i.Panel>
        </a.Item>
      {{/each}}
    </Accordion>
  </div>
</template>
