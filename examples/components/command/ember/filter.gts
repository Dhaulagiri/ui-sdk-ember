import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Command } from "ember-ui-sdk/command"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const commands = [
  { label: "Home" },
  { label: "Inbox", keywords: ["mail", "messages"] },
  { label: "Documents" },
  { label: "Downloads" },
  { label: "New file" },
  { label: "New folder" },
  { label: "Copy" },
  { label: "Paste" },
  { label: "Delete", keywords: ["remove", "trash"] },
  { label: "Zoom in" },
  { label: "Zoom out" },
  { label: "Search emoji", keywords: ["smiley", "face"] },
  { label: "Keyboard shortcuts", keywords: ["hotkeys"] },
  { label: "Settings", keywords: ["preferences"] },
]

const modes = [
  { value: "fuzzy", label: "Fuzzy" },
  { value: "contains", label: "Contains" },
  { value: "startsWith", label: "Starts with" },
  { value: "words", label: "Words" },
]

function words(item: { label: string }, query: string) {
  return query
    .toLowerCase()
    .split(/\s+/)
    .every((word) =>
      item.label
        .toLowerCase()
        .split(" ")
        .some((part) => part.startsWith(word))
    )
}

export default class Filter extends Component {
  commands = commands
  modes = modes
  @tracked mode = "fuzzy"

  get filter() {
    return this.mode === "words" ? words : this.mode
  }

  onModeChange = (next: string | null) => {
    if (next) this.mode = next
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select
          @items={{this.modes}}
          @value={{this.mode}}
          @onValueChange={{this.onModeChange}}
          as |s|
        >
          <s.Label>Filter</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.modes key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <Command @filter={{this.filter}} as |c|>
        <c.Input
          aria-label="Search commands"
          placeholder="Try “nf”, “zo in” or “smiley”"
        />
        <c.Empty>No results found.</c.Empty>
        <c.List>
          {{#each this.commands key="label" as |command|}}
            <c.Item @value={{command.label}} @keywords={{command.keywords}}>
              {{command.label}}
            </c.Item>
          {{/each}}
        </c.List>
      </Command>
    </div>
  </template>
}
