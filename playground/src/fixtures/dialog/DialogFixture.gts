import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { AlertDialog, createConfirm } from "ember-ui-sdk/alert-dialog"
import {
  createDialogController,
  Dialog,
  DialogTrigger,
} from "ember-ui-sdk/dialog"
import {
  alertDialogFixture,
  alertDialogOptions,
  dialogContentOptions,
  dialogFixture,
  dialogOptions,
  dialogParts,
} from "tests/fixtures/dialog.ts"
import {
  exposeDialogFixture,
  recordOpenChange,
} from "../../../../vendor/ui/apps/playground/src/fixtures/dialog/shared.ts"

export default class DialogFixture extends Component {
  controller = createDialogController()
  confirm = createConfirm()
  options = dialogOptions()
  alertOptions = alertDialogOptions()
  content = dialogContentOptions()
  parts = dialogParts()
  f = dialogFixture
  a = alertDialogFixture
  @tracked action = ""
  @tracked triggerShown = true

  constructor(owner: Owner, args: object) {
    super(owner, args)
    exposeDialogFixture(this.controller, this.confirm)
  }

  onOpenChange = (
    open: boolean,
    details: { reason: string; returnValue?: string }
  ) => {
    recordOpenChange("dialog", open, details)
    if (!open && details.returnValue) {
      this.action = details.returnValue
    }
  }
  onNestedOpenChange = (open: boolean, details: { reason: string }) =>
    recordOpenChange("nested", open, details)
  setAction = (action: string) => (this.action = action)
  removeTrigger = () => (this.triggerShown = false)
  openWithController = () => this.controller.open()

  <template>
    <div class="fixture">
      <button>Before</button>
      <Dialog
        @defaultOpen={{this.options.defaultOpen}}
        @modal={{this.options.modal}}
        @closeOnOutsidePress={{this.options.closeOnOutsidePress}}
        @container={{this.options.container}}
        @presentation={{this.options.presentation}}
        @controller={{this.controller}}
        @onOpenChange={{this.onOpenChange}}
        as |d|
      >
        {{#if this.triggerShown}}<d.Trigger
          >{{this.f.trigger}}</d.Trigger>{{/if}}
        {{#if this.parts.backdrop}}<d.Backdrop class="dialog-backdrop" />{{/if}}
        <d.Content
          class="dialog"
          @initialFocus={{this.content.initialFocus}}
          @finalFocus={{this.content.finalFocus}}
          @inline={{this.content.inline}}
        >
          {{#if this.parts.title}}<d.Title
              class="title"
            >{{this.f.title}}</d.Title>{{/if}}
          <d.Description
            class="description"
          >{{this.f.description}}</d.Description>
          <label class="field">
            {{this.f.field}}
            <input value={{this.f.defaultValue}} />
          </label>
          {{#if this.parts.long}}<p class="long">{{this.f.long}}</p>{{/if}}
          <div class="actions">
            <button
              {{on "click" (fn this.setAction "save")}}
            >{{this.f.action}}</button>
            <d.Close>{{this.f.close}}</d.Close>
            {{#if this.parts.removable}}
              <button
                {{on "click" this.removeTrigger}}
              >{{this.f.remove}}</button>
            {{/if}}
          </div>
          {{#if this.parts.form}}
            <form method="dialog">
              <button value={{this.f.form.value}}>{{this.f.form.label}}</button>
            </form>
          {{/if}}
          {{#if this.parts.nested}}
            <Dialog
              @defaultOpen={{this.parts.nestedOpen}}
              @onOpenChange={{this.onNestedOpenChange}}
              as |n|
            >
              <n.Trigger>{{this.f.nested.trigger}}</n.Trigger>
              {{#if this.parts.backdrop}}<n.Backdrop
                  class="dialog-backdrop"
                />{{/if}}
              <n.Content class="dialog">
                <n.Title class="title">{{this.f.nested.title}}</n.Title>
                <n.Close>{{this.f.nested.close}}</n.Close>
              </n.Content>
            </Dialog>
          {{/if}}
        </d.Content>
      </Dialog>
      <AlertDialog
        @defaultOpen={{this.alertOptions.defaultOpen}}
        @container={{this.alertOptions.container}}
        @controller={{this.confirm.controller}}
        as |a|
      >
        <a.Trigger>{{this.a.trigger}}</a.Trigger>
        {{#if this.parts.backdrop}}<a.Backdrop class="dialog-backdrop" />{{/if}}
        <a.Content class="dialog">
          <a.Title class="title">{{this.a.title}}</a.Title>
          <a.Description
            class="description"
          >{{this.a.description}}</a.Description>
          <div class="actions">
            <a.Close>{{this.a.cancel}}</a.Close>
            <a.Close
              @value="confirm"
              {{on "click" (fn this.setAction "delete")}}
            >
              {{this.a.action}}
            </a.Close>
          </div>
        </a.Content>
      </AlertDialog>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <button {{on "click" this.openWithController}}>Open with controller</button>
      {{#if this.parts.shortcut}}
        <DialogTrigger
          @controller={{this.controller}}
          @shortcut={{this.f.shortcut.keys}}
          as |trigger|
        >
          {{this.f.shortcut.trigger}}
          <trigger.Shortcut />
        </DialogTrigger>
      {{/if}}
    </div>
  </template>
}
