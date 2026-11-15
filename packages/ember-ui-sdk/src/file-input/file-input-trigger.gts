import Component from "@glimmer/component"
import { fileInput } from "@ui-sdk/core/file-input"
import { controllerTarget } from "../controller-target"
import { useFieldControl, type FieldContext } from "../field/context"
import type { PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import FileInputTriggerBinding from "./file-input-trigger-binding.gts"

const plainState = {
  value: [],
  disabled: false,
  required: false,
  dragging: false,
}

/** Opens the file picker. Inside a Field, the field's label names it with the button's own text. Outside the file input, it connects through `@controller`. */
class FileInputTrigger extends Component<
  PartSignature<
    typeof fileInput,
    "trigger",
    HTMLButtonElement,
    {
      controller?: object
      handle?: PrimitiveHandle<typeof fileInput>
      id?: string
      field?: FieldContext
    }
  >
> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  plain = { state: plainState, part: this.fieldControl.modifier }

  get handle() {
    return controllerTarget(this.args.controller, this.args.handle)
  }

  <template>
    {{#if this.handle}}
      <FileInputTriggerBinding
        ...attributes
        @handle={{this.handle}}
        @render={{@render}}
        {{this.fieldControl.modifier}}
        as |trigger|
      >{{yield trigger}}</FileInputTriggerBinding>
    {{else if @render}}
      {{yield this.plain}}
    {{else}}
      {{! Until the file input it names mounts, a trigger outside it is a plain button. }}
      <button type="button" ...attributes {{this.fieldControl.modifier}}>{{yield
          this.plain
        }}</button>
    {{/if}}
  </template>
}

export default FileInputTrigger
