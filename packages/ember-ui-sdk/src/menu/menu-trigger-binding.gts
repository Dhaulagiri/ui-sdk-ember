import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import type { Feature } from "@ui-sdk/core/renderer"
import { featureProps } from "./feature-props"
import { usePart, type PartSignature } from "../use-part"

// The bound part of a trigger, a button, or a context area, a div, once its menu is known.
class MenuTriggerBinding extends Component<
  PartSignature<
    typeof menu,
    "trigger",
    HTMLElement,
    { partName: "trigger" | "context-trigger"; feature?: Feature; tag: string }
  >
> {
  feature =
    this.args.feature && this.args.handle.instance.use(this.args.feature)
  part = usePart(
    this,
    () => this.args.handle,
    this.args.partName as "trigger",
    this.args.feature
      ? featureProps(this.args.feature, this.args.partName, () => this.args)
      : undefined
  )

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else if (isDiv @tag)}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

const isDiv = (tag: string) => tag === "div"

export default MenuTriggerBinding
