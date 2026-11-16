import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { Popover } from "ember-ui-sdk/popover"
import { useLog } from "../../../shared/ember/log"

export default class Draft extends Component {
  log = useLog(this)
  @tracked open = false
  @tracked note = ""
  @tracked asking = false

  get dismissible() {
    return this.note === ""
  }

  close = () => {
    this.open = false
    this.note = ""
    this.asking = false
  }

  onOpenChange = (next: boolean) => {
    if (next) {
      this.open = true
    } else {
      this.close()
    }
  }

  onDismissAttempt = (details: { reason: string }) => {
    this.log(`Kept open (${details.reason})`)
    this.asking = true
  }

  onInput = (event: Event) => {
    this.note = (event.currentTarget as HTMLTextAreaElement).value
  }

  keepEditing = (event: MouseEvent) => {
    this.asking = false
    const content = (event.currentTarget as Element).closest(
      '[data-slot="popover-content"]'
    )
    content?.querySelector("textarea")?.focus()
  }

  discard = () => {
    this.log("Discarded the note")
    this.close()
  }

  save = () => {
    this.log(this.note ? "Saved the note" : "Nothing to save")
    this.close()
  }

  <template>
    <Popover
      @open={{this.open}}
      @onOpenChange={{this.onOpenChange}}
      @dismissible={{this.dismissible}}
      @onDismissAttempt={{this.onDismissAttempt}}
      as |p|
    >
      <p.Trigger>Add Note</p.Trigger>
      <p.Content>
        <p.Title>Add a note</p.Title>
        <p.Description>Only your team can see it.</p.Description>
        <Field as |f|>
          <f.Label>Note</f.Label>
          <f.Control @render={{true}} as |control|>
            <textarea
              value={{this.note}}
              placeholder="Call the printer about the proofs."
              {{on "input" this.onInput}}
              {{control.part}}
            ></textarea>
          </f.Control>
        </Field>
        {{#if this.asking}}
          <div data-slot="row" role="alert">
            Discard your note?
            <div data-slot="row">
              <button
                type="button"
                data-size="sm"
                {{on "click" this.keepEditing}}
              >
                Keep Editing
              </button>
              <button
                type="button"
                data-size="sm"
                data-variant="solid"
                {{on "click" this.discard}}
              >
                Discard
              </button>
            </div>
          </div>
        {{else}}
          <div data-slot="row">
            <p.Close>Cancel</p.Close>
            <button type="button" data-variant="solid" {{on "click" this.save}}>
              Save
            </button>
          </div>
        {{/if}}
      </p.Content>
    </Popover>
  </template>
}
