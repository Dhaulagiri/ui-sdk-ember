import { registerDestructor } from "@ember/destroyable"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { shortcuts } from "@ui-sdk/core/shortcuts"
import { AlertDialog } from "ember-ui-sdk/alert-dialog"
import { createDialogController, Dialog } from "ember-ui-sdk/dialog"
import { Menu } from "ember-ui-sdk/menu"
import { Popover } from "ember-ui-sdk/popover"
import { dialogPatternsFixture } from "tests/fixtures/dialog.ts"
import { pendingAction, recordOpenChange } from "../../../../vendor/ui/apps/playground/src/fixtures/dialog-patterns/shared.ts"

export default class Fixture extends Component {
  f = dialogPatternsFixture
  rename = createDialogController()
  popoverRoot = document.getElementById("popover-root")
  pendingAction = pendingAction
  @tracked action = ""
  @tracked dirty = false
  @tracked details = false
  persistent = ["#chat"]

  constructor(owner: Owner, args: object) {
    super(owner, args)
    const f = this.f
    const stops = [
      shortcuts.register(f.pageShortcut, () => (this.action = "page shortcut")),
      shortcuts.register(f.slashShortcut, () => (this.action = "slash")),
      // Belongs to the dialog, so it runs while the dialog is open and modal.
      shortcuts.register(f.rename.save, () => (this.action = "saved"), {
        layer: () => document.querySelector(".dialog .field input"),
        allowInInput: true,
      }),
    ]
    registerDestructor(this, () => stops.forEach((stop) => stop()))
  }

  get notDirty() {
    return !this.dirty
  }

  setAction = (action: string) => (this.action = action)
  openRename = () => this.rename.open()
  markDirty = () => (this.dirty = true)
  onDismissAttempt = (details: { reason: string }) =>
    (this.action = `attempt:${details.reason}`)
  onRenameChange = (open: boolean, details: { reason: string }) => {
    recordOpenChange("rename", open, details)
    if (!open) {
      this.dirty = false
    }
  }
  onDeleteChange = (open: boolean, details: { reason: string }) =>
    recordOpenChange("delete", open, details)
  onDetailsAction = (value: string) => {
    if (value === "details") {
      this.details = true
    }
  }
  setDetails = (open: boolean) => (this.details = open)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Menu as |m|>
        <m.Trigger
          @shortcut={{this.f.menu.shortcut}}
        >{{this.f.menu.trigger}}</m.Trigger>
        <m.Content>
          <m.Item
            @value="rename"
            @onSelect={{this.openRename}}
          >{{this.f.menu.rename}}</m.Item>
          <m.Item @value="close">{{this.f.menu.close}}</m.Item>
        </m.Content>
      </Menu>
      <Dialog
        @controller={{this.rename}}
        @dismissible={{this.notDirty}}
        @persistentElements={{this.persistent}}
        @onDismissAttempt={{this.onDismissAttempt}}
        @onOpenChange={{this.onRenameChange}}
        as |d|
      >
        <d.Trigger @shortcut={{this.f.rename.shortcut}} as |trigger|>
          {{this.f.rename.trigger}}
          <trigger.Shortcut class="shortcut" />
        </d.Trigger>
        <d.Backdrop class="dialog-backdrop" />
        <d.Content class="dialog">
          <d.Title class="title">{{this.f.rename.title}}</d.Title>
          <label class="field">
            {{this.f.rename.field}}
            <input
              value={{this.f.rename.defaultValue}}
              {{on "input" this.markDirty}}
            />
          </label>
          <d.Close>{{this.f.rename.cancel}}</d.Close>
        </d.Content>
      </Dialog>
      <AlertDialog @onOpenChange={{this.onDeleteChange}} as |a|>
        <a.Trigger>{{this.f.remove.trigger}}</a.Trigger>
        <a.Backdrop class="dialog-backdrop" />
        <a.Content class="dialog">
          <a.Title class="title">{{this.f.remove.title}}</a.Title>
          <a.Description
            class="description"
          >{{this.f.remove.description}}</a.Description>
          <a.Close>{{this.f.remove.cancel}}</a.Close>
          <a.Close
            @value="confirm"
            @action={{this.pendingAction}}
          >{{this.f.remove.action}}</a.Close>
        </a.Content>
      </AlertDialog>
      <label>
        {{this.f.search}}
        <input />
      </label>
      <button
        id="chat"
        {{on "click" (fn this.setAction "chat")}}
      >{{this.f.chat}}</button>
      <Popover @container={{this.popoverRoot}} as |p|>
        <p.Trigger
          @shortcut={{this.f.share.shortcut}}
        >{{this.f.share.trigger}}</p.Trigger>
        <p.Content>
          <p.Title>{{this.f.share.title}}</p.Title>
          <Menu @container={{this.popoverRoot}} as |m|>
            <m.Trigger>{{this.f.share.menu}}</m.Trigger>
            <m.Content>
              <m.Item @value="copy">{{this.f.share.item}}</m.Item>
            </m.Content>
          </Menu>
          <Dialog @container={{this.popoverRoot}} as |d|>
            <d.Trigger>{{this.f.share.dialog}}</d.Trigger>
            <d.Content class="dialog">
              <d.Title class="title">{{this.f.share.dialogTitle}}</d.Title>
              <d.Close>{{this.f.share.done}}</d.Close>
            </d.Content>
          </Dialog>
        </p.Content>
      </Popover>
      <Menu @onAction={{this.onDetailsAction}} as |m|>
        <m.Trigger>{{this.f.details.menu}}</m.Trigger>
        <m.Content>
          <m.Item @value="details">{{this.f.details.item}}</m.Item>
        </m.Content>
      </Menu>
      <Dialog @open={{this.details}} @onOpenChange={{this.setDetails}} as |d|>
        <d.Content class="dialog">
          <d.Title class="title">{{this.f.details.title}}</d.Title>
          <d.Close>{{this.f.details.done}}</d.Close>
        </d.Content>
      </Dialog>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
