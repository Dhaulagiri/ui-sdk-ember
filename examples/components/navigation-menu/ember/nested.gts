import { ChevronDown, ChevronRight } from "lucide"
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

const groups = [
  {
    value: "overlays",
    label: "Overlays",
    links: [
      { title: "Dialog", href: "#" },
      { title: "Popover", href: "#" },
      { title: "Tooltip", href: "#" },
    ],
  },
  {
    value: "forms",
    label: "Forms",
    links: [
      { title: "Input", href: "#" },
      { title: "Select", href: "#" },
      { title: "Checkbox", href: "#" },
    ],
  },
]

<template>
  <NavigationMenu aria-label="Main" as |n|>
    <n.List as |l|>
      <l.Item @value="guides" as |i|>
        <i.Trigger>
          Guides
          {{icon ChevronDown}}
        </i.Trigger>
        <i.Content as |c|>
          <ul>
            {{#each gettingStarted key="title" as |link|}}
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
      <l.Item @value="components" as |i|>
        <i.Trigger>
          Components
          {{icon ChevronDown}}
        </i.Trigger>
        <i.Content as |c|>
          <c.Menu @orientation="vertical" as |m|>
            <m.List as |ml|>
              {{#each groups key="value" as |group|}}
                <ml.Item @value={{group.value}} as |gi|>
                  <gi.Trigger>
                    {{group.label}}
                    {{icon ChevronRight}}
                  </gi.Trigger>
                  <gi.Content @sideOffset={{9}} @alignOffset={{-5}} as |gc|>
                    <ul>
                      {{#each group.links key="title" as |link|}}
                        <li>
                          <gc.Link href={{link.href}}>
                            {{link.title}}
                          </gc.Link>
                        </li>
                      {{/each}}
                    </ul>
                  </gi.Content>
                </ml.Item>
              {{/each}}
            </m.List>
          </c.Menu>
        </i.Content>
      </l.Item>
    </n.List>
    <n.Viewport @sideOffset={{8}} />
  </NavigationMenu>
</template>
