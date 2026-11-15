import Component from "@glimmer/component"
import { timeline } from "@ui-sdk/core/timeline"
import { usePart, type PartSignature } from "../use-part"

/** When its event happened, as a `<time>`. Pass `datetime` so machines can read it. It describes the event. */
class TimelineTime extends Component<
  PartSignature<typeof timeline, "time", HTMLElement>
> {
  part = usePart(this, () => this.args.handle, "time")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <time ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</time>
    {{/if}}
  </template>
}

export default TimelineTime
