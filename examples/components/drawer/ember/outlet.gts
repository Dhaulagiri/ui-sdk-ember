import Component from "@glimmer/component"
import { Drawer } from "ember-ui-sdk/drawer"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Textarea } from "ember-ui-sdk/textarea"

const messages = [
  { from: "Inès", text: "The proofs are back from the printer." },
  { from: "Kofi", text: "Lunch on Thursday?" },
  { from: "Wren", text: "Pushed the fix for the release build." },
  { from: "Tomasz", text: "Can you review the launch checklist?" },
]

const keyframes = { scale: [1, 0.94], borderRadius: ["0px", "24px"] }

export default class Outlet extends Component {
  messages = messages
  keyframes = keyframes

  <template>
    <Drawer as |d|>
      <div>
        <d.Outlet @keyframes={{this.keyframes}}>
          <div data-slot="row">
            <span>Inbox</span>
            <d.Trigger data-variant="solid">Compose</d.Trigger>
          </div>
          <ul data-slot="list">
            {{#each this.messages key="from" as |message|}}
              <li>
                <div>{{message.from}}</div>
                <div data-slot="hint">{{message.text}}</div>
              </li>
            {{/each}}
          </ul>
        </d.Outlet>
      </div>
      <d.Backdrop />
      <d.Content>
        <div data-slot="grip" aria-hidden="true"></div>
        <div data-slot="stack">
          <d.Title>New message</d.Title>
          <d.Description>Write a quick note to the team.</d.Description>
        </div>
        <Field as |f|>
          <f.Label>To</f.Label>
          <Input @defaultValue="Design team" @field={{f.field}} />
        </Field>
        <Field as |f|>
          <f.Label>Message</f.Label>
          <Textarea placeholder="What's new?" @field={{f.field}} />
        </Field>
        <div data-slot="stack">
          <d.Close data-variant="solid" @value="send">Send</d.Close>
        </div>
      </d.Content>
    </Drawer>
  </template>
}
