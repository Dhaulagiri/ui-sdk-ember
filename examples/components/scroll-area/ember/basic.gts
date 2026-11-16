import { ScrollArea } from "ember-ui-sdk/scroll-area"

const tags = Array.from(
  { length: 50 },
  (_, index) => `v1.2.0-beta.${50 - index}`
)

<template>
  <ScrollArea as |s|>
    <s.Viewport role="region" aria-label="Tags">
      <s.Content>
        <h3>Tags</h3>
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
</template>
