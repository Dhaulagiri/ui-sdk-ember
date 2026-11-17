import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"
import SelectValue from "./select-value.gts"
import SelectValueIcon from "./select-value-icon.gts"

// The bound trigger, once its select is known.
class SelectTriggerBinding extends Component<
  PartSignature<typeof select, "trigger", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Value=(component SelectValue handle=@handle)
        ValueIcon=(component SelectValueIcon handle=@handle)
      )
      as |trigger|
    }}
      {{#if @render}}
        {{yield trigger}}
      {{else}}
        <button ...attributes {{this.part.modifier}}>
          {{~#if (has-block)}}{{yield trigger}}{{else}}<SelectValue
              @handle={{@handle}}
            />{{/if~}}
        </button>
      {{/if}}
    {{/let}}
  </template>
}

export default SelectTriggerBinding
