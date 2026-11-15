import Component from "@glimmer/component"
import { passwordInput } from "@ui-sdk/core/password-input"
import { usePart, type PartSignature } from "../use-part"

/** Shows and hides the password. Name it by what it does, like "Show password": it's a toggle button, and `aria-pressed` says whether the password is shown. */
class PasswordInputToggle extends Component<
  PartSignature<typeof passwordInput, "toggle", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "toggle")

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

export default PasswordInputToggle
