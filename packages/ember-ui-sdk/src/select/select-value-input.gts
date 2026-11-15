import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

// One hidden input per selected value of a select with `multiple`.
class SelectValueInput extends Component<{
  Args: { handle: PrimitiveHandle<typeof select>; value: string }
}> {
  part = usePart(
    this,
    () => this.args.handle,
    "value-input",
    () => ({
      id: this.args.value,
    })
  )

  <template><input {{this.part.modifier}} /></template>
}

export default SelectValueInput
