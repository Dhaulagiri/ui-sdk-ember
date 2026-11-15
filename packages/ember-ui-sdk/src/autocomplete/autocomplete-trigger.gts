import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { usePart, type PartSignature } from "../use-part"

/** A button that opens and closes the suggestions, out of the tab order. */
class AutocompleteTrigger extends Component<
  PartSignature<typeof autocomplete, "trigger", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default AutocompleteTrigger
