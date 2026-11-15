import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  fromText,
  toText,
  TokenInput,
  type TokenInputValue,
} from "ember-ui-sdk/token-input"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import {
  pendingSelect,
  tokenInputFixture as f,
  tokenInputOptions,
  tokenTriggers,
} from "tests/fixtures/token-input.ts"

export default class TokenInputFixture extends Component {
  f = f
  options = tokenInputOptions()
  triggers = tokenTriggers()
  initial = fromText(this.options.value)
  @tracked current: TokenInputValue = this.initial
  @tracked action = ""
  @tracked submitted = ""

  get defaultValue() {
    return this.options.controlled ? undefined : this.initial
  }

  get value() {
    return this.options.controlled ? this.current : undefined
  }

  get form() {
    return this.options.otherForm ? "other" : undefined
  }

  get onInputSubmit() {
    return this.options.form ? undefined : this.setSubmitted
  }

  setSubmitted = (next: TokenInputValue) => {
    this.submitted = toText(next)
  }

  onValueChange = (next: TokenInputValue, details: { reason: string }) => {
    this.current = next
    this.action = `${details.reason}:${toText(next)}`
  }

  onSelect = (_selected: unknown, details: { trigger: string }) =>
    this.options.pending && details.trigger === "@"
      ? pendingSelect({ fail: this.options.fail })
      : undefined

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = String(
      new FormData(event.currentTarget as HTMLFormElement).get(f.name)
    )
  }

  onOtherSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = `other:${new FormData(event.currentTarget as HTMLFormElement).get(f.name)}`
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <form
        class="composer"
        aria-label={{f.formLabel}}
        {{on "submit" this.onSubmit}}
      >
        <TokenInput
          @tokenDeletion={{this.options.tokenDeletion}}
          @submitShortcut={{this.options.submitShortcut}}
          @copy={{this.options.copy}}
          @disabled={{this.options.disabled}}
          @readOnly={{this.options.readOnly}}
          @name={{f.name}}
          @form={{this.form}}
          @defaultValue={{this.defaultValue}}
          @value={{this.value}}
          @onValueChange={{this.onValueChange}}
          @onSubmit={{this.onInputSubmit}}
          as |t|
        >
          <label class="label" id="prompt-label">{{f.label}}</label>
          <t.Editor
            aria-labelledby="prompt-label"
            class="editor"
            @placeholder={{f.placeholder}}
          />
          <TriggerMenu
            @triggers={{this.triggers}}
            @editor={{t.editor}}
            @onSelect={{this.onSelect}}
            as |m|
          >
            <m.Hint class="hint" />
            <m.Content class="popup list-popup">
              <m.List as |list|>
                {{#each list.state.items key="value" as |item|}}
                  <m.Item
                    class="item"
                    @value={{item.value}}
                    @label={{item.label}}
                    @disabled={{item.disabled}}
                  >{{item.label}}</m.Item>
                {{/each}}
              </m.List>
            </m.Content>
          </TriggerMenu>
          <t.Tokens as |token p|>
            {{~! ~}}<p.Token class="token">{{token.label}}<p.Remove
              >{{" ×"}}</p.Remove></p.Token>{{~! ~}}
          </t.Tokens>
        </TokenInput>
        <button type="submit">{{f.submit}}</button>
      </form>
      {{#if this.options.otherForm}}
        <form
          id="other"
          aria-label="Other"
          {{on "submit" this.onOtherSubmit}}
        ></form>
      {{/if}}
      <textarea aria-label={{f.scratch}}></textarea>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
