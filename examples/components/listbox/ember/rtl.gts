import { Listbox } from "ember-ui-sdk/listbox"

const views = [
  { value: "day", label: "יום" },
  { value: "week", label: "שבוע" },
  { value: "month", label: "חודש" },
]

<template>
  <div dir="rtl">
    <Listbox
      @orientation="horizontal"
      @defaultValue="day"
      aria-label="תצוגה"
      as |l|
    >
      {{#each views key="value" as |view|}}
        <l.Item @value={{view.value}}>
          {{view.label}}
        </l.Item>
      {{/each}}
    </Listbox>
  </div>
</template>
