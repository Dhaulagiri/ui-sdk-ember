import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Menu } from "ember-ui-sdk/menu"

export default class MenuUnmountFixture extends Component {
  @tracked open = false

  onOpenChange = (next: boolean) => (this.open = next)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Menu @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |m|>
        <m.Trigger>Actions</m.Trigger>
        {{#if this.open}}
          <m.Content class="popup fill-in">
            <m.Item class="item" @value="rename">Rename</m.Item>
            <m.Item class="item" @value="delete">Delete</m.Item>
          </m.Content>
        {{/if}}
      </Menu>
    </div>
  </template>
}
