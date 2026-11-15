import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import type { ConfirmEntry, ConfirmOptions } from "@ui-sdk/core/dialog"
import { AlertDialog } from "../alert-dialog.ts"

/** The alert dialog the host renders for a `confirm()` question. */
class HostedConfirm extends Component<{ Args: { entry: ConfirmEntry } }> {
  constructor(owner: Owner, args: HostedConfirm["args"]) {
    super(owner, args)
    queueMicrotask(() => args.entry.open())
  }

  get question() {
    return (this.args.entry.payload ?? {}) as Partial<ConfirmOptions>
  }

  onOpenChangeComplete = (open: boolean) => {
    if (!open) {
      this.args.entry.done()
    }
  }

  <template>
    <AlertDialog
      @controller={{@entry.controller}}
      @onOpenChangeComplete={{this.onOpenChangeComplete}}
      as |a|
    >
      <a.Content>
        <a.Title>{{this.question.title}}</a.Title>
        {{#if this.question.description}}
          <a.Description>{{this.question.description}}</a.Description>
        {{/if}}
        <div>
          <a.Close>{{if
              this.question.cancelLabel
              this.question.cancelLabel
              "Cancel"
            }}</a.Close>
          <a.Close @value="confirm">{{if
              this.question.confirmLabel
              this.question.confirmLabel
              "Continue"
            }}</a.Close>
        </div>
      </a.Content>
    </AlertDialog>
  </template>
}

export default HostedConfirm
