import Component from "@glimmer/component"
import { CreditCard, Settings, User } from "lucide"
import { Command } from "ember-ui-sdk/command"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const settings = [
  { value: "profile", label: "Profile", icon: User, shortcut: "mod+p" },
  { value: "billing", label: "Billing", icon: CreditCard, shortcut: "mod+b" },
  { value: "settings", label: "Settings", icon: Settings, shortcut: "mod+s" },
]

export default class Shortcuts extends Component {
  log = useLog(this)
  settings = settings

  onAction = (value: string) => {
    this.log(`Ran ${value}`)
  }

  <template>
    <div data-slot="stack">
      <Command @onAction={{this.onAction}} as |c|>
        <c.Input aria-label="Search settings" placeholder="Search settings…" />
        <c.List>
          <c.Group as |g|>
            <g.Label>Settings</g.Label>
            {{#each this.settings key="value" as |setting|}}
              <g.Item
                @value={{setting.value}}
                @shortcut={{setting.shortcut}}
                as |item|
              >
                <item.Icon>{{icon setting.icon}}</item.Icon>
                <span>{{setting.label}}</span>
                <item.Shortcut as |s|>{{s.state.text}}</item.Shortcut>
              </g.Item>
            {{/each}}
          </c.Group>
        </c.List>
      </Command>
    </div>
  </template>
}
