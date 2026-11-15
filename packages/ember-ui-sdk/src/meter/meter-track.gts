import Component from "@glimmer/component"
import { meter } from "@ui-sdk/core/meter"
import { usePart, type PartSignature } from "../use-part"

/** The rail the indicator fills. */
class MeterTrack extends Component<
  PartSignature<typeof meter, "track", HTMLDivElement>
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

export default MeterTrack
