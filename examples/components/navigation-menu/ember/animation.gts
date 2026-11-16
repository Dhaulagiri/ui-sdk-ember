import Component from "@glimmer/component"
import { ChevronDown } from "lucide"
import { NavigationMenu } from "ember-ui-sdk/navigation-menu"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

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

export default class Animation extends Component {
  log = useLog(this)
  gettingStarted = gettingStarted
  components = components

  onValueChange = (value: string | null) => {
    this.log(value ? `Showing ${value}` : "Closing")
  }

  onOpenChangeComplete = (open: boolean) => {
    this.log(open ? "Finished opening" : "Finished closing")
  }

  <template>
    <NavigationMenu
      aria-label="Main"
      @onValueChange={{this.onValueChange}}
      @onOpenChangeComplete={{this.onOpenChangeComplete}}
      as |n|
    >
      <n.List as |l|>
        <l.Item @value="guides" as |i|>
          <i.Trigger>
            Guides
            {{icon ChevronDown}}
          </i.Trigger>
          <i.Content as |c|>
            <ul>
              {{#each this.gettingStarted key="title" as |page|}}
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
              {{#each this.components key="title" as |page|}}
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
      </n.List>
      <n.Viewport @sideOffset={{8}} data-variant="slide" />
    </NavigationMenu>
  </template>
}
