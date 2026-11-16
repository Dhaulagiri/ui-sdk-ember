import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import {
  createTokenInputController,
  TokenInput,
  type Token,
} from "ember-ui-sdk/token-input"

const draft = [
  "Compare ",
  { type: "file", value: "src/routes.ts", label: "routes.ts" },
  " with ",
]

const loadFile = () => new Promise<void>((resolve) => setTimeout(resolve, 800))

export default class Controller extends Component {
  prompt = createTokenInputController()
  draft = draft

  firstToken = () =>
    this.prompt
      .getValue()
      .find((segment): segment is Token => typeof segment !== "string")

  keepFocus = (event: MouseEvent) => {
    event.preventDefault()
  }

  attachFile = () => {
    this.prompt.insert(
      { type: "file", value: "package.json", label: "package.json" },
      { at: "end", resolve: loadFile() }
    )
  }

  showPath = () => {
    const token = this.firstToken()
    if (token) {
      this.prompt.updateToken(token.id!, { label: token.value })
    }
  }

  removeFirst = () => {
    const token = this.firstToken()
    if (token) {
      this.prompt.removeToken(token.id!)
    }
  }

  undo = () => {
    this.prompt.undo()
  }

  clear = () => {
    this.prompt.clear()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button
          type="button"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.attachFile}}
        >
          Attach File
        </button>
        <button
          type="button"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.showPath}}
        >Show Path</button>
        <button
          type="button"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.removeFirst}}
        >Remove First</button>
        <button
          type="button"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.undo}}
        >Undo</button>
        <button
          type="button"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.clear}}
        >Clear</button>
      </div>
      <Field as |f|>
        <f.Label>Prompt</f.Label>
        <TokenInput
          @controller={{this.prompt}}
          @defaultValue={{this.draft}}
          @field={{f.field}}
          as |t|
        >
          <t.Editor />
        </TokenInput>
      </Field>
    </div>
  </template>
}
