import Component from "@glimmer/component"
import { rating } from "@ui-sdk/core/rating"
import { usePart, type PartSignature } from "../use-part"

class RatingRadio extends Component<
  PartSignature<typeof rating, "radio", HTMLButtonElement>
> {
  radio = usePart(
    this,
    () => this.args.handle,
    "radio",
    () => ({
      value: this.args.value,
    })
  )
  input = usePart(
    this,
    () => this.args.handle,
    "input",
    () => ({
      value: this.args.value,
    })
  )

  <template>
    <button {{this.radio.modifier}}></button>
    <input {{this.input.modifier}} />
  </template>
}

export default RatingRadio
