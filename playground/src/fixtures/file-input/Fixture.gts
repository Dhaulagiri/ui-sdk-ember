import type { ModifierLike } from "@glint/template"
import { capabilities, on, setModifierManager } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import {
  FileInput,
  type FileInputValueChangeDetails,
  type FileRejection,
} from "ember-ui-sdk/file-input"
import {
  describeChange,
  fileInputFixture as f,
  fileInputOptions,
  serializeFiles,
} from "tests/fixtures/file-input.ts"

const ref = setModifierManager(
  () => ({
    capabilities: capabilities("3.22", { disableAutoTracking: true }),
    createModifier: () => ({}),
    installModifier: (
      _: object,
      el: Element,
      { positional }: { positional: unknown[] }
    ) => (positional[0] as (el: Element) => void)(el),
    updateModifier: () => {},
    destroyModifier: () => {},
  }),
  function () {} as unknown as ModifierLike<{
    Element: Element
    Args: { Positional: [(el: any) => unknown] }
  }>
)

export default class Fixture extends Component {
  f = f
  options = fileInputOptions()
  @tracked action = ""
  @tracked count = 0
  @tracked submitted = ""
  @tracked attachments: File[] = []
  note: HTMLTextAreaElement | null = null
  changed = false

  setNote = (el: HTMLTextAreaElement) => (this.note = el)
  getNote = () => this.note

  get controlledValue() {
    return this.options.controlled ? this.attachments : undefined
  }

  onChange =
    (kind: string) => (value: File[], details: FileInputValueChangeDetails) => {
      if (this.options.cancel) {
        details.cancel()
      }
      this.changed = true
      queueMicrotask(() => (this.changed = false))
      this.action = describeChange(kind, details)
      this.count++
      const ignored =
        this.options.ignoreRemovals && details.reason === "remove-press"
      if (kind === "attachments" && !details.canceled && !ignored) {
        this.attachments = value
      }
    }

  onReject =
    (kind: string) =>
    (rejected: FileRejection[], details: { reason: string }) => {
      if (!this.changed) {
        this.action = describeChange(kind, { ...details, rejected })
      }
    }

  onAttachments = this.onChange("attachments")
  onAttachmentsReject = this.onReject("attachments")
  onAvatar = this.onChange("avatar")
  onAvatarReject = this.onReject("avatar")
  onFolder = this.onChange("folder")
  onFolderReject = this.onReject("folder")
  onPage = this.onChange("page")
  onPageReject = this.onReject("page")

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = serializeFiles(event.currentTarget as HTMLFormElement)
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <form
        class="form"
        id={{f.formId}}
        aria-label={{f.formLabel}}
        {{on "submit" this.onSubmit}}
      >
        <Field as |field|>
          <field.Label>{{f.field.label}}</field.Label>
          <FileInput
            class="file-input"
            @field={{field.field}}
            @name={{this.options.name}}
            @accept={{f.attachments.accept}}
            @multiple={{this.options.multiple}}
            @maxFiles={{this.options.maxFiles}}
            @maxSize={{f.attachments.maxSize}}
            @minSize={{f.attachments.minSize}}
            @required={{this.options.required}}
            @disabled={{this.options.disabled}}
            @value={{this.controlledValue}}
            @onValueChange={{this.onAttachments}}
            @onReject={{this.onAttachmentsReject}}
            as |i|
          >
            <i.Dropzone
              class="zone"
              role="group"
              aria-label={{f.zone.label}}
              @pasteTarget={{this.getNote}}
              as |zone|
            >
              <p>{{if zone.state.dragging f.zone.dragging f.zone.text}}</p>
              <i.Trigger>{{f.trigger.label}}</i.Trigger>
            </i.Dropzone>
            <i.List
              aria-label={{f.list.label}}
              class="file-list"
              as |list file row|
            >
              <row.Item class="file-item" as |item|>
                <span>{{item.state.file.name}}</span>
                <item.Remove>×</item.Remove>
              </row.Item>
            </i.List>
          </FileInput>
          <field.Description>{{f.field.description}}</field.Description>
          <field.Error
            class="field-error"
            @match="valueMissing"
          >{{f.field.error}}</field.Error>
        </Field>
        <label>
          {{f.note.label}}
          <textarea name={{f.note.name}} {{ref this.setNote}}></textarea>
        </label>
        <div class="row">
          <button type="submit">Send</button>
          <button type="reset">Reset</button>
        </div>
      </form>
      <FileInput
        @accept={{f.avatar.accept}}
        @capture={{f.avatar.capture}}
        @onValueChange={{this.onAvatar}}
        @onReject={{this.onAvatarReject}}
        as |i|
      >
        <i.Trigger>{{f.avatar.label}}</i.Trigger>
      </FileInput>
      <FileInput
        @directory={{true}}
        @onValueChange={{this.onFolder}}
        @onReject={{this.onFolderReject}}
        as |i|
      >
        <i.Trigger>{{f.folder.label}}</i.Trigger>
      </FileInput>
      {{#if this.options.page}}
        <FileInput
          @multiple={{true}}
          @onValueChange={{this.onPage}}
          @onReject={{this.onPageReject}}
          as |i|
        >
          <i.Dropzone
            class="page-zone"
            role="group"
            aria-label={{f.page.label}}
            @target="document"
          >
            {{f.page.text}}
          </i.Dropzone>
        </FileInput>
      {{/if}}
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Actions">{{this.count}}</output>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
