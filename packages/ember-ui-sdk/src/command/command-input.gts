import Component from "@glimmer/component"
import { command } from "@ui-sdk/core/command"
import { usePart, type PartSignature } from "../use-part"

/** The search field. It keeps focus while arrow keys move the highlight. Name it with `aria-label`. */
class CommandInput extends Component<
  PartSignature<typeof command, "input", HTMLInputElement>
> {
  part = usePart(this, () => this.args.handle, "input")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <input ...attributes {{this.part.modifier}} />
    {{/if}}
  </template>
}

export default CommandInput
