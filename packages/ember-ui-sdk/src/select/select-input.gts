import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"

/** A search field inside the content that filters the items. */
class SelectInput extends Component<
  PartSignature<typeof select, "input", HTMLInputElement>
> {
  part = usePart(this, () => this.args.handle, "input")

  <template><input ...attributes {{this.part.modifier}} /></template>
}

export default SelectInput
