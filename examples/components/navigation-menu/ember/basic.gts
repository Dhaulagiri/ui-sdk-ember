import Component from "@glimmer/component"
import {
  ArrowRight,
  ChevronDown,
  Circle,
  CircleCheck,
  CircleQuestionMark,
} from "lucide"
import { NavigationMenu } from "ember-ui-sdk/navigation-menu"
import { icon } from "../../../shared/ember/icon"

const gettingStarted = [
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
    description: "Style parts with data attributes, CSS variables and any CSS.",
  },
]

const components = [
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
  {
    title: "Tabs",
    href: "#",
    description:
      "Shows one panel of content at a time, picked from a list of tabs.",
  },
  {
    title: "Tooltip",
    href: "#",
    description:
      "A short label for a control, shown on hover or keyboard focus.",
  },
]

const statuses = [
  { title: "Backlog", href: "#", icon: CircleQuestionMark },
  { title: "To do", href: "#", icon: Circle },
  { title: "Done", href: "#", icon: CircleCheck },
  { title: "All issues", href: "#", icon: ArrowRight, mirror: true },
]

<template>
  <NavigationMenu aria-label="Main" as |n|>
    <n.List as |l|>
      <l.Item @value="getting-started" as |i|>
        <i.Trigger>
          Getting started
          {{icon ChevronDown}}
        </i.Trigger>
        <i.Content as |c|>
          <ul data-slot="grid">
            <li>
              <c.Link href="#" data-variant="featured">
                <span>ui-sdk</span>
                <span data-slot="hint">
                  Accessible components for React, Vue, Svelte, Solid and Web
                  Components.
                </span>
              </c.Link>
            </li>
            {{#each gettingStarted key="title" as |page|}}
              <li>
                <c.Link href={{page.href}}>
                  <span>{{page.title}}</span>
                  <span data-slot="hint">{{page.description}}</span>
                </c.Link>
              </li>
            {{/each}}
          </ul>
        </i.Content>
      </l.Item>
      <l.Item @value="components" as |i|>
        <i.Trigger>
          Components
          {{icon ChevronDown}}
        </i.Trigger>
        <i.Content as |c|>
          <ul data-slot="grid">
            {{#each components key="title" as |page|}}
              <li>
                <c.Link href={{page.href}}>
                  <span>{{page.title}}</span>
                  <span data-slot="hint">{{page.description}}</span>
                </c.Link>
              </li>
            {{/each}}
          </ul>
        </i.Content>
      </l.Item>
      <l.Item @value="with-icon" as |i|>
        <i.Trigger>
          With Icon
          {{icon ChevronDown}}
        </i.Trigger>
        <i.Content as |c|>
          <ul>
            {{#each statuses key="title" as |status|}}
              <li>
                <c.Link href={{status.href}} as |link|>
                  <link.Icon @mirror={{status.mirror}}>{{icon
                      status.icon
                    }}</link.Icon>
                  {{status.title}}
                </c.Link>
              </li>
            {{/each}}
          </ul>
        </i.Content>
      </l.Item>
      <l.Item as |i|>
        <i.Link href="#">Docs</i.Link>
      </l.Item>
    </n.List>
    <n.Viewport @sideOffset={{8}} />
  </NavigationMenu>
</template>
