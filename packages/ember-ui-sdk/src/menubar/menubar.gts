import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import Component from "@glimmer/component"
import { menubar } from "@ui-sdk/core/menubar"
import Menu from "../menu/menu.gts"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"

/** A row of menus, like a desktop app's: one tab stop, arrow keys between the triggers and between open menus. Yields a `Menu` that joins it. */
class Menubar extends Component<{
  Element: HTMLDivElement
  Args: {
    /** Which arrow keys move between menus: left and right, or up and down. */
    orientation?: "horizontal" | "vertical"
    /** Whether arrow keys wrap from the last menu to the first. */
    loop?: boolean
    /** Stops every menu from opening. Triggers stay focusable with `aria-disabled`. */
    disabled?: boolean
    /** The `modal` setting of every menu in the menubar that doesn't set its own. */
    modal?: boolean | "pointer"
    /** Opens, closes and focuses the menubar from anywhere. */
    controller?: object
    /** Logs every state change. */
    debug?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [
      RootYield<typeof menubar> & {
        Menu: WithBoundArgs<typeof Menu, "menubar">
      },
    ]
  }
}> {
  handle = usePrimitive(this, menubar)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Menu=(component Menu menubar=this.handle)
      )
      as |m|
    }}
      {{#if @render}}
        {{yield m}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield m}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default Menubar
