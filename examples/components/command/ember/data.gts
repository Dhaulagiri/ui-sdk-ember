import Component from "@glimmer/component"
import { Command } from "ember-ui-sdk/command"
import { useLog } from "../../../shared/ember/log"

const commands = [
  {
    type: "group",
    label: "Navigation",
    items: [
      { value: "home", label: "Go home", keywords: ["start"] },
      { value: "inbox", label: "Open inbox", shortcut: "mod+i" },
    ],
  },
  { type: "separator" },
  {
    type: "group",
    label: "Preferences",
    items: [
      {
        value: "theme",
        label: "Change theme…",
        items: [
          { value: "light", label: "Light" },
          { value: "dark", label: "Dark" },
          { value: "system", label: "System" },
        ],
      },
      {
        value: "language",
        label: "Change language…",
        items: ["English", "Français", "Deutsch", "日本語"],
      },
      { value: "sign-out", label: "Sign out", shortcut: "mod+shift+q" },
    ],
  },
]

export default class Data extends Component {
  log = useLog(this)
  commands = commands

  onAction = (value: string) => {
    this.log(`Ran ${value}`)
  }

  <template>
    <div data-slot="stack">
      <Command @items={{this.commands}} @onAction={{this.onAction}} as |c|>
        <c.Input aria-label="Search commands" placeholder="Type a command…" />
        <c.Empty>No results found.</c.Empty>
        <c.List as |list|>
          {{#each list.state.items key="@identity" as |entry|}}
            {{#if entry.items}}
              <c.Group as |g|>
                <g.Label>{{entry.label}}</g.Label>
                {{#each entry.items key="@identity" as |command|}}
                  <g.Item
                    @value={{command.value}}
                    @label={{command.label}}
                    @disabled={{command.disabled}}
                    @shortcut={{command.shortcut}}
                    as |item|
                  >
                    {{command.label}}
                    {{#if command.shortcut}}<item.Shortcut />{{/if}}
                  </g.Item>
                {{/each}}
              </c.Group>
            {{else}}
              <c.Separator />
            {{/if}}
          {{/each}}
        </c.List>
      </Command>
    </div>
  </template>
}
