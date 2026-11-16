import { ScrollArea } from "ember-ui-sdk/scroll-area"

const tags = Array.from({ length: 40 }, (_, index) => `وسم ${index + 1}`)

<template>
  <div dir="rtl">
    <ScrollArea as |s|>
      <s.Viewport>
        <s.Content>
          <h4>الوسوم</h4>
          {{#each tags as |tag|}}
            <div>
              {{tag}}
            </div>
          {{/each}}
        </s.Content>
      </s.Viewport>
      <s.Scrollbar as |sb|>
        <sb.Thumb />
      </s.Scrollbar>
    </ScrollArea>
  </div>
</template>
