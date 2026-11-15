import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"

/** The selected item's label in the trigger, or the placeholder. */
class SelectValue extends Component<
  PartSignature<typeof select, "value", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "value")

  get text() {
    const { state } = this.part
    return state.placeholder
      ? (this.args.placeholder ?? this.args.handle.state.placeholder ?? "")
      : state.label
  }

  <template>
    <span ...attributes {{this.part.modifier}}>
      {{~#if (has-block)}}{{yield
          this.part.yielded
        }}{{else}}{{this.text}}{{/if~}}
    </span>
  </template>
}

export default SelectValue
