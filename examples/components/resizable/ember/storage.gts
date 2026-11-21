import Component from "@glimmer/component"
import { Resizable } from "ember-ui-sdk/resizable"

export default class Storage extends Component {
  session = {
    getItem: (key: string) => sessionStorage.getItem(key),
    setItem: (key: string, value: string) => sessionStorage.setItem(key, value),
  }

  <template>
    <Resizable @autoSaveId="docs-storage" @storage={{this.session}} as |r|>
      <r.Panel @id="session-chats" @defaultSize={{35}} @minSize={{20}}>
        <h3>Messages</h3>
        <ul>
          <li>Inès Moreau</li>
          <li>Kofi Mensah</li>
          <li>Wren Takahashi</li>
        </ul>
      </r.Panel>
      <r.Handle aria-label="Resize messages" />
      <r.Panel @id="session-thread" @minSize={{20}}>
        <h3>Inès Moreau</h3>
        <span data-slot="hint">Can we move the review to Friday?</span>
      </r.Panel>
    </Resizable>
  </template>
}
