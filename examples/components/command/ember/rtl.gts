import { Command } from "ember-ui-sdk/command"

const commands = [
  { value: "calendar", label: "التقويم" },
  { value: "search", label: "البحث" },
  { value: "settings", label: "الإعدادات" },
  { value: "profile", label: "الملف الشخصي" },
]

<template>
  <div dir="rtl" data-slot="stack">
    <Command as |c|>
      <c.Input aria-label="ابحث عن أمر" placeholder="ابحث…" />
      <c.Empty>لا توجد نتائج.</c.Empty>
      <c.List>
        {{#each commands key="value" as |item|}}
          <c.Item @value={{item.value}} @label={{item.label}}>
            {{item.label}}
          </c.Item>
        {{/each}}
      </c.List>
    </Command>
  </div>
</template>
