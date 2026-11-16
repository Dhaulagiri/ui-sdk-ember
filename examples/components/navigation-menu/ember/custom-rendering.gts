import Component from "@glimmer/component"
import { concat } from "@ember/helper"
import { Minus, Plus } from "lucide"
import { NavigationMenu } from "ember-ui-sdk/navigation-menu"
import { icon } from "../../../shared/ember/icon"

const sections = [
  {
    value: "guides",
    label: "Guides",
    links: [
      {
        title: "Introduction",
        href: "#",
        description: "Unstyled components with one core for every framework.",
      },
      {
        title: "Installation",
        href: "#",
        description:
          "Add the package for your framework and render your first part.",
      },
      {
        title: "Styling",
        href: "#",
        description:
          "Style parts with data attributes, CSS variables and any CSS.",
      },
    ],
  },
  {
    value: "components",
    label: "Components",
    links: [
      {
        title: "Alert Dialog",
        href: "#",
        description:
          "Asks for a decision before anything else on the page can be used.",
      },
      {
        title: "Hover Card",
        href: "#",
        description:
          "A preview of what a link points to, for people who pause on it.",
      },
      {
        title: "Progress",
        href: "#",
        description: "Shows how far along a task is, like an upload.",
      },
      {
        title: "Scroll Area",
        href: "#",
        description: "Scrolls its content with scrollbars you can style.",
      },
    ],
  },
]

const isFirst = (index: number) => index === 0

<template>
  <NavigationMenu aria-label="Main" as |n|>
    <n.List as |l|>
      {{#each sections key="value" as |item|}}
        <l.Item @value={{item.value}} as |i|>
          <i.Trigger @render={{true}} as |t|>
            <button {{t.part}}>
              {{item.label}}
              {{#if t.state.open}}{{icon Minus}}{{else}}{{icon Plus}}{{/if}}
            </button>
          </i.Trigger>
          <i.Content @render={{true}} as |c|>
            <section {{c.part}} aria-label={{item.label}}>
              <p data-slot="hint">
                {{if
                  c.state.motion
                  (concat "Moved in " c.state.motion)
                  "Opened"
                }}
              </p>
              <ul>
                {{#each item.links key="title" as |link index|}}
                  <li>
                    <c.Link
                      href={{link.href}}
                      @current={{isFirst index}}
                      as |linkItem|
                    >
                      <span>{{link.title}}</span>
                      {{#if linkItem.state.current}}
                        <span data-slot="hint" data-show="current">You're here</span>
                      {{/if}}
                    </c.Link>
                  </li>
                {{/each}}
              </ul>
            </section>
          </i.Content>
        </l.Item>
      {{/each}}
      <l.Item @value="pricing" as |i|>
        <i.Trigger @disabled={{true}} @render={{true}} as |t|>
          <button {{t.part}}>
            Pricing
            {{#if t.state.disabled}}
              <span data-slot="badge" data-show="disabled">Soon</span>
            {{/if}}
          </button>
        </i.Trigger>
        <i.Content>Plans for teams.</i.Content>
      </l.Item>
    </n.List>
    <n.Viewport @sideOffset={{8}} />
  </NavigationMenu>
</template>
