import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"

/** What the list shows while the search matches nothing. */
class SelectEmpty extends Component<
  PartSignature<typeof select, "empty", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "empty")

  <template>
    <div ...attributes {{this.part.modifier}}>
      {{~#if this.part.state.empty}}{{yield this.part.yielded}}{{/if~}}
    </div>
  </template>
}

export default SelectEmpty
