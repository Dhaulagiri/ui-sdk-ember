import Component from "@glimmer/component"
import { Menu } from "ember-ui-sdk/menu"
import { useLog } from "../../../shared/ember/log"

const positions = [
  { value: "top", label: "Top" },
  { value: "bottom", label: "Bottom" },
  { value: "right", label: "Right" },
]

const densities = [
  { value: "compact", label: "Compact" },
  { value: "comfortable", label: "Comfortable" },
]

export default class RadioGroup extends Component {
  log = useLog(this)
  positions = positions
  densities = densities

  onPosition = (value: string) => {
    this.log(`Panel at the ${value}`)
  }

  onDensity = (value: string) => {
    this.log(`${value} density`)
  }

  <template>
    <Menu as |m|>
      <m.Trigger>Panel</m.Trigger>
      <m.Content>
        <m.RadioGroup
          @name="position"
          @defaultValue="bottom"
          @onValueChange={{this.onPosition}}
          as |r|
        >
          <r.Label>Position</r.Label>
          {{#each this.positions key="value" as |option|}}
            <r.Item @value={{option.value}} as |item|>
              <item.Indicator />
              {{option.label}}
            </r.Item>
          {{/each}}
        </m.RadioGroup>
        <m.Separator />
        <m.RadioGroup
          @defaultValue="comfortable"
          @onValueChange={{this.onDensity}}
          as |r|
        >
          <r.Label>Density</r.Label>
          {{#each this.densities key="value" as |option|}}
            <r.Item @value={{option.value}} as |item|>
              <item.Indicator />
              {{option.label}}
            </r.Item>
          {{/each}}
        </m.RadioGroup>
      </m.Content>
    </Menu>
  </template>
}
