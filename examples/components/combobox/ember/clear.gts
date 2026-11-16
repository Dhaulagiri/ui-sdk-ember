import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "sveltekit", label: "SvelteKit" },
  { value: "nuxt", label: "Nuxt" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "solidstart", label: "SolidStart" },
  { value: "qwik", label: "Qwik City" },
]

const frameworkLabel = (value: string) =>
  frameworks.find((framework) => framework.value === value)?.label ?? value

export default class Clear extends Component {
  log = useLog(this)
  frameworkLabel = frameworkLabel
  @tracked value: string | null = "sveltekit"

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    this.log(`${next ? frameworkLabel(next) : "Cleared"} (${details.reason})`)
  }

  <template>
    <Combobox
      @value={{this.value}}
      @onValueChange={{this.onValueChange}}
      @itemToLabel={{this.frameworkLabel}}
      as |c|
    >
      <div data-slot="stack">
        <c.Label>Framework</c.Label>
        <div data-slot="row">
          <c.Input placeholder="Select a framework" />
          <c.Clear aria-label="Clear framework">{{icon X}}</c.Clear>
          <c.Trigger aria-label="Show frameworks">{{icon
              ChevronDown
            }}</c.Trigger>
        </div>
      </div>
      <c.Content>
        <c.Empty>No frameworks found.</c.Empty>
        <c.List>
          {{#each frameworks key="value" as |framework|}}
            <c.Item
              @value={{framework.value}}
              @label={{framework.label}}
              as |item|
            >
              {{framework.label}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
  </template>
}
