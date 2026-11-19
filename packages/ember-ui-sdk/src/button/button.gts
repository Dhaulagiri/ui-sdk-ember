import Component from "@glimmer/component"
import {
  button as buttonPrimitive,
  type ButtonActionDetails,
} from "@ui-sdk/core/button"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"

/** A button, or a link or any element that acts as one through `@render`. */
class Button extends Component<{
  Element: HTMLButtonElement
  Args: {
    /** Stops presses. */
    disabled?: boolean
    /** Keeps a disabled button in the tab order with `aria-disabled`. */
    focusableWhenDisabled?: boolean
    /** What the button does in a form. */
    type?: "button" | "submit" | "reset"
    /** What screen readers hear once the button has been pending for a second. */
    pendingAnnouncement?: string
    /** Logs every state change with its reason. */
    debug?: boolean
    /**
     * Runs when the button is pressed. Return a Promise to make the button
     * pending until it settles.
     */
    onClick?: (event: MouseEvent, details: ButtonActionDetails) => unknown
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [Pick<RootYield<typeof buttonPrimitive>, "part" | "state">]
  }
}> {
  handle = usePrimitive(this, buttonPrimitive, () => ({
    action: (event, details) =>
      this.args.onClick?.(event as MouseEvent, details),
  }))
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#if @render}}
      {{yield this.root.yielded}}
    {{else}}
      <button ...attributes {{this.root.modifier}}>{{yield
          this.root.yielded
        }}</button>
    {{/if}}
  </template>
}

export default Button
