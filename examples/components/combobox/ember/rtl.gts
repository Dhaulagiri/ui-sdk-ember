import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

const cities = [
  { value: "cairo", label: "القاهرة" },
  { value: "dubai", label: "دبي" },
  { value: "riyadh", label: "الرياض" },
  { value: "beirut", label: "بيروت" },
  { value: "amman", label: "عمّان" },
  { value: "rabat", label: "الرباط" },
]

<template>
  <div dir="rtl">
    <Combobox as |c|>
      <div data-slot="stack">
        <c.Label>المدينة</c.Label>
        <div data-slot="row">
          <c.Input placeholder="ابحث عن مدينة…" />
          <c.Trigger aria-label="عرض المدن">{{icon ChevronDown}}</c.Trigger>
        </div>
      </div>
      <c.Content>
        <c.Empty>لا توجد نتائج.</c.Empty>
        <c.List>
          {{#each cities key="value" as |city|}}
            <c.Item @value={{city.value}} @label={{city.label}} as |item|>
              {{city.label}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
  </div>
</template>
