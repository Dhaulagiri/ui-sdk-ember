import Component from "@glimmer/component"
import { slider } from "@ui-sdk/core/slider"
import { usePart, type PartSignature } from "../use-part"

/** The formatted value, a range joined with an en dash. Content replaces it. */
class SliderValue extends Component<
  PartSignature<typeof slider, "value", HTMLOutputElement>
> {
  part = usePart(this, () => this.args.handle, "value")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <output ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{this.part.state.text}}{{/if~}}
      </output>
    {{/if}}
  </template>
}

export default SliderValue
