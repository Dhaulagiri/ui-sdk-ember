import { Autocomplete } from "ember-ui-sdk/autocomplete"

const pages = [
  { title: "Installation", section: "Get Started", href: "#installation" },
  { title: "Composition", section: "Concepts", href: "#composition" },
  { title: "Build Your Own", section: "Concepts", href: "#build-your-own" },
  { title: "Styling", section: "Guides", href: "#styling" },
  { title: "API Reference", section: "Reference", href: "#api-reference" },
  { title: "Accessibility", section: "Reference", href: "#accessibility" },
]

<template>
  <Autocomplete as |c|>
    <div data-slot="stack">
      <c.Label>Jump to</c.Label>
      <c.Input placeholder="e.g. Styling" />
    </div>
    <c.Content>
      <c.Empty>No sections found.</c.Empty>
      <c.List>
        {{#each pages key="href" as |page|}}
          <c.Item
            @value={{page.title}}
            @label={{page.title}}
            @render={{true}}
            as |p|
          >
            <a {{p.part}} href={{page.href}}>
              {{page.title}}
              <span data-slot="hint">{{page.section}}</span>
            </a>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
