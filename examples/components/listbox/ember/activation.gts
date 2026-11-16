import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { Listbox } from "ember-ui-sdk/listbox"
import { File } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const files = [
  { value: "readme", label: "README.md" },
  { value: "package", label: "package.json" },
  { value: "tsconfig", label: "tsconfig.json" },
  { value: "index", label: "index.ts" },
  { value: "styles", label: "styles.css" },
  { value: "logo", label: "logo.svg" },
]

export default class Activation extends Component {
  log = useLog(this)

  onValueChange = (value: string[], details: { reason: string }) => {
    this.log(`${value.length} selected (${details.reason})`)
  }

  <template>
    <Listbox
      @multiple={{true}}
      @activation="automatic"
      @defaultValue={{array "readme"}}
      @onValueChange={{this.onValueChange}}
      aria-label="Files"
      as |l|
    >
      {{#each files key="value" as |file|}}
        <l.Item @value={{file.value}} as |i|>
          <i.Icon>{{icon File}}</i.Icon>
          {{file.label}}
        </l.Item>
      {{/each}}
    </Listbox>
  </template>
}
