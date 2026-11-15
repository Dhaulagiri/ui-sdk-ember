import Component from "@glimmer/component"
import { progress } from "@ui-sdk/core/progress"
import { usePart, type PartSignature } from "../use-part"

/** Names the progress. */
class ProgressLabel extends Component<
  PartSignature<typeof progress, "label", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "label")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</span>
    {{/if}}
  </template>
}

export default ProgressLabel
