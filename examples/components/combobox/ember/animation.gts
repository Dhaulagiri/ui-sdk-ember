import Component from "@glimmer/component"
import { Check, ChevronDown } from "lucide"
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

export default class Animation extends Component {
  log = useLog(this)

  onOpenChangeComplete = (open: boolean) => {
    this.log(open ? "Finished opening" : "Finished closing")
  }

  <template>
    <Combobox @onOpenChangeComplete={{this.onOpenChangeComplete}} as |c|>
      <div data-slot="stack">
        <c.Label>Framework</c.Label>
        <div data-slot="row">
          <c.Input placeholder="Select a framework" />
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
              <item.Indicator @keepMounted={{true}}>{{icon
                  Check
                }}</item.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
  </template>
}
