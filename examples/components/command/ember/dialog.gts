import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  Calculator,
  Calendar,
  CreditCard,
  Search,
  Settings,
  Smile,
  User,
} from "lucide"
import { Command } from "ember-ui-sdk/command"
import { Dialog } from "ember-ui-sdk/dialog"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const commands = [
  { value: "calendar", label: "Calendar", icon: Calendar },
  { value: "emoji", label: "Search Emoji", icon: Smile },
  {
    value: "calculator",
    label: "Calculator",
    icon: Calculator,
    disabled: true,
  },
  { value: "profile", label: "Profile", icon: User },
  { value: "billing", label: "Billing", icon: CreditCard },
  { value: "settings", label: "Settings", icon: Settings },
]

export default class DialogExample extends Component {
  log = useLog(this)
  commands = commands
  @tracked open = false

  onOpenChange = (next: boolean) => {
    this.open = next
  }

  onAction = (value: string) => {
    this.log(`Ran ${value}`)
    this.open = false
  }

  <template>
    <div data-slot="stack">
      <Dialog @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |d|>
        <d.Trigger @shortcut="mod+k" @render={{true}} as |t|>
          <button {{t.part}} type="button">
            Search…
            <d.Shortcut as |s|>{{s.state.text}}</d.Shortcut>
          </button>
        </d.Trigger>
        <d.Backdrop />
        <d.Content>
          <d.Title>Command palette</d.Title>
          <Command @onAction={{this.onAction}} as |c|>
            <div data-slot="row">
              {{icon Search}}
              <c.Input
                aria-label="Search commands"
                placeholder="Type a command or search…"
              />
            </div>
            <c.Empty>No results found.</c.Empty>
            <c.List>
              <c.Group as |g|>
                <g.Label>Suggestions</g.Label>
                {{#each this.commands key="value" as |command|}}
                  <g.Item
                    @value={{command.value}}
                    @disabled={{command.disabled}}
                    as |item|
                  >
                    <item.Icon>{{icon command.icon}}</item.Icon>
                    {{command.label}}
                  </g.Item>
                {{/each}}
              </c.Group>
            </c.List>
          </Command>
        </d.Content>
      </Dialog>
    </div>
  </template>
}
