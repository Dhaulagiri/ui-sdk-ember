import { ChevronDown } from "lucide"
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

<template>
  <NavigationMenu aria-label="Main" @openOnHover={{false}} as |n|>
    <n.List as |l|>
      {{#each sections key="value" as |section|}}
        <l.Item @value={{section.value}} as |i|>
          <i.Trigger>
            {{section.label}}
            {{icon ChevronDown}}
          </i.Trigger>
          <i.Content as |c|>
            <ul>
              {{#each section.links key="title" as |link|}}
                <li>
                  <c.Link href={{link.href}}>
                    <span>{{link.title}}</span>
                    <span data-slot="hint">{{link.description}}</span>
                  </c.Link>
                </li>
              {{/each}}
            </ul>
          </i.Content>
        </l.Item>
      {{/each}}
    </n.List>
    <n.Viewport @sideOffset={{8}} />
  </NavigationMenu>
</template>
