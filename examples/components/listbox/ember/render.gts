import Component from "@glimmer/component"
import { Listbox } from "ember-ui-sdk/listbox"
import { ExternalLink } from "lucide"
import { icon } from "../../../shared/ember/icon"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "nuxt", label: "Nuxt" },
  { value: "sveltekit", label: "SvelteKit" },
]

export default class Render extends Component {
  <template>
    <Listbox
      @defaultValue="next"
      @activation="manual"
      aria-label="Framework docs"
      as |l|
    >
      {{#each frameworks key="value" as |framework|}}
        <l.Item
          @value={{framework.value}}
          @label={{framework.label}}
          @render={{true}}
          as |i|
        >
          <a {{i.part}} href="#{{framework.value}}">
            <span>{{framework.label}}</span>
            {{#if i.state.selected}}
              {{icon ExternalLink}}
            {{/if}}
          </a>
        </l.Item>
      {{/each}}
    </Listbox>
  </template>
}
