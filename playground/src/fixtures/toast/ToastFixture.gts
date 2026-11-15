import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { confirm } from "ember-ui-sdk/alert-dialog"
import { Dialog } from "ember-ui-sdk/dialog"
import { OverlayHost } from "ember-ui-sdk/overlays"
import { ToastRegion, type ToastContent } from "ember-ui-sdk/toast"
import { toastFixture, toastOptions, usesHost } from "tests/fixtures/toast.ts"
import { createFixtureToasts } from "../../../../vendor/ui/apps/playground/src/fixtures/toast/shared.ts"

export default class ToastFixture extends Component {
  f = toastFixture
  host = usesHost()
  options = toastOptions()
  @tracked action = ""
  toasts = createFixtureToasts<ToastContent>((value) => (this.action = value))
  hostOptions = { ...this.options, class: "toast-region" }

  basic = () => this.toasts.basic()
  success = () => this.toasts.success()
  error = () => this.toasts.error()
  promise = () => this.toasts.promise()

  ask = async () => {
    const { title, confirm: confirmLabel, cancel } = toastFixture.confirm
    const yes = await confirm({ title, confirmLabel, cancelLabel: cancel })
    this.action = yes ? "confirmed" : "declined"
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <button {{on "click" this.basic}}>{{this.f.basic.trigger}}</button>
      <button {{on "click" this.success}}>{{this.f.success.trigger}}</button>
      <button {{on "click" this.error}}>{{this.f.error.trigger}}</button>
      <button {{on "click" this.promise}}>{{this.f.promise.trigger}}</button>
      <Dialog as |d|>
        <d.Trigger>{{this.f.dialog.trigger}}</d.Trigger>
        <d.Content class="dialog">
          <d.Title class="title">{{this.f.dialog.title}}</d.Title>
          <button {{on "click" this.basic}}>{{this.f.dialog.toast}}</button>
          <d.Close>{{this.f.dialog.close}}</d.Close>
        </d.Content>
      </Dialog>
      {{#if this.host}}<button
          {{on "click" this.ask}}
        >{{this.f.confirm.trigger}}</button>{{/if}}
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      {{#if this.host}}
        <OverlayHost @toast={{this.hostOptions}} as |toast item t|>
          <t.Toast class="toast">
            <t.Title />
            <t.Description />
            <t.Action />
            {{#if toast.cancel}}
              <t.Close
                @action={{toast.cancel.onCancel}}
              >{{toast.cancel.label}}</t.Close>
            {{/if}}
          </t.Toast>
        </OverlayHost>
      {{else}}
        <ToastRegion
          class="toast-region"
          @toaster={{this.toasts.toast}}
          @side={{this.options.side}}
          @align={{this.options.align}}
          @maxVisible={{this.options.maxVisible}}
          @expanded={{this.options.expanded}}
          @shortcut={{this.options.shortcut}}
          as |toast item t|
        >
          <t.Toast class="toast">
            <t.Title class="toast-title" />
            <t.Description class="toast-description" />
            <t.Action class="toast-action" />
            <t.Close class="toast-close">{{this.f.dismiss}}</t.Close>
          </t.Toast>
        </ToastRegion>
      {{/if}}
    </div>
  </template>
}
