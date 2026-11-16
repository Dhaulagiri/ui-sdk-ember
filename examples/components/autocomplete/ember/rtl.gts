import { Autocomplete } from "ember-ui-sdk/autocomplete"

const cities = ["القاهرة", "القدس", "الرباط", "الرياض", "بيروت", "دبي", "عمّان"]

<template>
  <div dir="rtl">
    <Autocomplete @inlineComplete={{true}} as |c|>
      <div data-slot="stack">
        <c.Label>المدينة</c.Label>
        <c.Input placeholder="مثلاً: دبي" />
      </div>
      <c.Content>
        <c.List>
          {{#each cities key="@identity" as |city|}}
            <c.Item @value={{city}}>
              {{city}}
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Autocomplete>
  </div>
</template>
