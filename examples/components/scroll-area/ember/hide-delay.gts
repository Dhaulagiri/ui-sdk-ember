import { ScrollArea } from "ember-ui-sdk/scroll-area"

const delays = [
  { value: 0, label: "No delay" },
  { value: 2000, label: "2000 ms delay" },
]
const tags = Array.from(
  { length: 20 },
  (_, index) => `v1.2.0-beta.${50 - index}`
)

<template>
  <div data-slot="grid">
    {{#each delays key="value" as |delay|}}
      <div data-slot="stack">
        <span data-slot="hint">{{delay.label}}</span>
        <ScrollArea @type="scroll" @scrollHideDelay={{delay.value}} as |s|>
          <s.Viewport>
            <s.Content>
              <ul>
                {{#each tags as |tag|}}
                  <li>{{tag}}</li>
                {{/each}}
              </ul>
            </s.Content>
          </s.Viewport>
          <s.Scrollbar as |sb|>
            <sb.Thumb />
          </s.Scrollbar>
        </ScrollArea>
      </div>
    {{/each}}
  </div>
</template>
