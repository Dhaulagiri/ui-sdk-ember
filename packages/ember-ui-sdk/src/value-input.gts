import Component from "@glimmer/component"
import { usePart } from "./use-part"
import type { PrimitiveHandle } from "./use-primitive"

// One hidden input per selected value of a list with `multiple`.
class ValueInput extends Component<{
  Args: { handle: PrimitiveHandle; value: string }
}> {
  part = usePart(
    this,
    () => this.args.handle,
    "value-input" as never,
    () => ({ id: this.args.value, value: this.args.value }) as never
  )

  <template><input {{this.part.modifier}} /></template>
}

export default ValueInput
