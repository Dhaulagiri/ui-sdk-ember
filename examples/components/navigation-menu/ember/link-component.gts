import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { tracked } from "@glimmer/tracking"
import { ChevronDown } from "lucide"
import { NavigationMenu } from "ember-ui-sdk/navigation-menu"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const gettingStarted = [
  {
    title: "Introduction",
    href: "#introduction",
    description: "Unstyled components with one core for every framework.",
  },
  {
    title: "Installation",
    href: "#installation",
    description:
      "Add the package for your framework and render your first part.",
  },
  {
    title: "Styling",
    href: "#styling",
    description: "Style parts with data attributes, CSS variables and any CSS.",
  },
]

export default class LinkComponent extends Component {
  log = useLog(this)
  gettingStarted = gettingStarted
  @tracked route = "#introduction"

  navigate = (href: string, event: MouseEvent) => {
    event.preventDefault()
    this.route = href
    this.log(`Navigated to ${href}`)
  }

  isCurrent = (href: string) => this.route === href

  <template>
    <NavigationMenu aria-label="Docs" as |n|>
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
                  <c.Link
                    href={{page.href}}
                    @current={{this.isCurrent page.href}}
                    {{on "click" (fn this.navigate page.href)}}
                  >
                    <span>{{page.title}}</span>
                    <span data-slot="hint">{{page.description}}</span>
                  </c.Link>
                </li>
              {{/each}}
            </ul>
          </i.Content>
        </l.Item>
        <l.Item as |i|>
          <i.Link
            href="#components"
            @current={{this.isCurrent "#components"}}
            {{on "click" (fn this.navigate "#components")}}
          >
            Components
          </i.Link>
        </l.Item>
      </n.List>
      <n.Viewport @sideOffset={{8}} />
    </NavigationMenu>
  </template>
}
