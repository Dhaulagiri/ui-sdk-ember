import type { TOC } from "@ember/component/template-only"
import type { toastRegion, Toast as ToastData } from "@ui-sdk/core/toast"
import type { PrimitiveHandle } from "../use-primitive"
import Content from "./content.gts"
import ToastAction from "./toast-action.gts"
import ToastClose from "./toast-close.gts"
import ToastDescription from "./toast-description.gts"
import ToastTitle from "./toast-title.gts"
import Toast from "./toast.gts"

const present = (value: unknown) => value != null

/** A toast rendered from its data, with the parts. */
const DataToast: TOC<{
  Args: {
    handle: PrimitiveHandle<typeof toastRegion>
    toast: ToastData<unknown>
  }
}> = <template>
  <Toast @handle={{@handle}} @toast={{@toast}}>
    <div>
      {{#if (present @toast.title)}}<ToastTitle
          @handle={{@handle}}
          @toast={{@toast}}
        />{{/if}}
      {{#if (present @toast.description)}}<ToastDescription
          @handle={{@handle}}
          @toast={{@toast}}
        />{{/if}}
    </div>
    {{#if @toast.action}}<ToastAction
        @handle={{@handle}}
        @toast={{@toast}}
      />{{/if}}
    {{#if @toast.cancel}}
      <ToastClose
        @handle={{@handle}}
        @toast={{@toast}}
        @action={{@toast.cancel.onCancel}}
      >
        <Content @content={{@toast.cancel.label}} />
      </ToastClose>
    {{/if}}
  </Toast>
</template>

export default DataToast
