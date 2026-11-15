import Component from "@glimmer/component"
import { progress } from "@ui-sdk/core/progress"
import { usePart, type PartSignature } from "../use-part"

/** The rail the indicator fills. */
class ProgressTrack extends Component<
  PartSignature<typeof progress, "track", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "track")

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

export default ProgressTrack
