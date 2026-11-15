import Component from "@glimmer/component"
import { progress } from "@ui-sdk/core/progress"
import { usePart, type PartSignature } from "../use-part"

/** The formatted value, like "40%". Content replaces it. */
class ProgressValue extends Component<
  PartSignature<typeof progress, "value", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "value")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>{{#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{this.part.state.text}}{{/if}}</span>
    {{/if}}
  </template>
}

export default ProgressValue
