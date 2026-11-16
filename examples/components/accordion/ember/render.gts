import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"

const steps = [
  {
    value: "install",
    label: "Install the package",
    content: "Add it with your package manager. It has no dependencies.",
  },
  {
    value: "import",
    label: "Import the parts",
    content: "Import the accordion parts you need from the package.",
  },
  {
    value: "style",
    label: "Style it",
    content: "Every part renders its state as data attributes you can style.",
  },
]

export default class Render extends Component {
  position = (index: number) =>
    index >= 0 ? String(index + 1).padStart(2, "0") : ""

  <template>
    <Accordion @multiple={{true}} @defaultValue={{array "install"}} as |a|>
      {{#each steps key="value" as |step|}}
        <a.Item @value={{step.value}} as |i|>
          <i.Header @render={{true}} as |h|>
            <h4 {{h.part}}>
              <i.Trigger @render={{true}} as |t|>
                <button {{t.part}}>
                  <span data-slot="hint" aria-hidden="true">
                    {{this.position t.state.index}}
                  </span>
                  <span>{{step.label}}</span>
                  <span data-slot="hint" aria-hidden="true">
                    {{if t.state.open "Hide" "Show"}}
                  </span>
                </button>
              </i.Trigger>
            </h4>
          </i.Header>
          <i.Panel>{{step.content}}</i.Panel>
        </a.Item>
      {{/each}}
    </Accordion>
  </template>
}
