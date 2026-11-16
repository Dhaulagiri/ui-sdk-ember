import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

export default class DirtyForm extends Component {
  @tracked open = false
  @tracked dirty = false
  @tracked asking = false

  get clean() {
    return !this.dirty
  }

  close = () => {
    this.open = false
    this.dirty = false
    this.asking = false
  }

  onOpenChange = (next: boolean) => {
    if (next) {
      this.open = true
    } else {
      this.close()
    }
  }

  onDismissAttempt = () => {
    this.asking = true
  }

  onInput = (event: Event) => {
    this.dirty = (event.currentTarget as HTMLTextAreaElement).value !== ""
  }

  keepEditing = () => {
    this.asking = false
    document.querySelector<HTMLTextAreaElement>("#post")?.focus()
  }

  <template>
    <Dialog
      @open={{this.open}}
      @onOpenChange={{this.onOpenChange}}
      @dismissible={{this.clean}}
      @onDismissAttempt={{this.onDismissAttempt}}
      as |d|
    >
      <d.Trigger>Write a Post</d.Trigger>
      <d.Backdrop />
      <d.Content>
        <div data-slot="stack">
          <d.Title>New post</d.Title>
          <d.Description>Share an update with your team.</d.Description>
        </div>
        <Field as |f|>
          <f.Label>Post</f.Label>
          <Textarea
            id="post"
            @field={{f.field}}
            placeholder="What's new?"
            {{on "input" this.onInput}}
          />
        </Field>
        {{#if this.asking}}
          <div data-slot="row" role="alert">
            Discard your changes?
            <div data-slot="row">
              <button type="button" {{on "click" this.keepEditing}}>Keep Editing</button>
              <button
                data-variant="solid"
                type="button"
                {{on "click" this.close}}
              >Discard</button>
            </div>
          </div>
        {{else}}
          <div data-slot="row">
            <d.Close data-variant="solid" @value="post">Post</d.Close>
          </div>
        {{/if}}
      </d.Content>
    </Dialog>
  </template>
}
