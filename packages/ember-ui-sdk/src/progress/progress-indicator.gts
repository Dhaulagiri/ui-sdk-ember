import Component from "@glimmer/component"
import { progress } from "@ui-sdk/core/progress"
import { usePart, type PartSignature } from "../use-part"

/** The filled part of the track, as wide as the value. */
class ProgressIndicator extends Component<
  PartSignature<typeof progress, "indicator", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "indicator")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default ProgressIndicator
