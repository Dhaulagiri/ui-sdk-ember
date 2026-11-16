import Component from "@glimmer/component"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const timezones = Array.from({ length: 27 }, (_, index) => {
  const offset = index - 12
  const label = `UTC${offset < 0 ? "−" : "+"}${String(Math.abs(offset)).padStart(2, "0")}:00`
  return { value: `utc${offset}`, label }
})

export default class Scrollable extends Component {
  log = useLog(this)

  onHighlight = (value: string | null, details: { index: number }) => {
    if (value) {
      this.log(
        `Focused ${timezones[details.index].label} (${details.index + 1} of ${timezones.length})`
      )
    }
  }

  <template>
    <Listbox
      @defaultValue="utc9"
      @onHighlight={{this.onHighlight}}
      aria-label="Time zone"
      as |l|
    >
      {{#each timezones key="value" as |zone index|}}
        <l.Item @value={{zone.value}} @index={{index}} as |i|>
          {{zone.label}}
          <i.Indicator>{{icon Check}}</i.Indicator>
        </l.Item>
      {{/each}}
    </Listbox>
  </template>
}
