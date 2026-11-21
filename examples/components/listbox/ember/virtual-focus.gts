import Component from "@glimmer/component"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "nuxt", label: "Nuxt" },
  { value: "sveltekit", label: "SvelteKit" },
]

export default class VirtualFocus extends Component {
  log = useLog(this)

  onValueChange = (value: string | null, details: { reason: string }) => {
    this.log(`${value ?? "Nothing"} (${details.reason})`)
  }

  <template>
    <Listbox
      @activation="manual"
      @virtualFocus={{true}}
      @onValueChange={{this.onValueChange}}
      aria-label="Framework"
      as |l|
    >
      {{#each frameworks key="value" as |framework|}}
        <l.Item @value={{framework.value}} as |i|>
          {{framework.label}}
          <i.Indicator>{{icon Check}}</i.Indicator>
        </l.Item>
      {{/each}}
    </Listbox>
  </template>
}
