import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"

/** Announces the list's status, like loading, to screen readers. */
class SelectStatus extends Component<
  PartSignature<typeof select, "status", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "status")

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

export default SelectStatus
