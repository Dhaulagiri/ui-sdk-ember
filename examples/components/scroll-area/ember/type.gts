import { ScrollArea, type ScrollAreaType } from "ember-ui-sdk/scroll-area"

const types: ScrollAreaType[] = ["hover", "scroll", "auto", "always"]
const tags = Array.from(
  { length: 20 },
  (_, index) => `v1.2.0-beta.${50 - index}`
)

<template>
  <div data-slot="grid">
    {{#each types as |type|}}
      <div data-slot="stack">
        <code>type="{{type}}"</code>
        <ScrollArea @type={{type}} as |s|>
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
