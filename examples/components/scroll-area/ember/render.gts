import { ScrollArea } from "ember-ui-sdk/scroll-area"

const tags = Array.from(
  { length: 50 },
  (_, index) => `v1.2.0-beta.${50 - index}`
)

<template>
  <ScrollArea @render={{true}} as |s|>
    <section {{s.part}}>
      <s.Viewport @render={{true}} aria-label="Releases" as |v|>
        <article {{v.part}}>
          <s.Content>
            <ul>
              {{#each tags as |tag|}}
                <li>{{tag}}</li>
              {{/each}}
            </ul>
          </s.Content>
        </article>
      </s.Viewport>
      <p data-slot="hint" aria-hidden="true">
        {{if s.state.atStart "Scroll for older releases" "More releases below"}}
      </p>
      <s.Scrollbar as |sb|>
        <sb.Thumb />
      </s.Scrollbar>
    </section>
  </ScrollArea>
</template>
