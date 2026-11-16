import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const languages = [
  { value: "ar", label: "العربية" },
  { value: "en", label: "الإنجليزية" },
  { value: "fr", label: "الفرنسية" },
  { value: "es", label: "الإسبانية" },
  { value: "de", label: "الألمانية" },
]

<template>
  <div dir="rtl">
    <Field as |f|>
      <f.Label>اللغة</f.Label>
      <Select @placeholder="اختر لغة" as |s|>
        <s.Trigger @field={{f.field}}>
          <s.Value />
          {{icon ChevronDown}}
        </s.Trigger>
        <s.Content>
          {{#each languages key="value" as |language|}}
            <s.Item @value={{language.value}} as |item|>
              {{language.label}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
    </Field>
  </div>
</template>
