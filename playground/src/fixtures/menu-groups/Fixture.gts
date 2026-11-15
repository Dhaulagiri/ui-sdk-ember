import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { registerDestructor } from "@ember/destroyable"
import { Menu } from "ember-ui-sdk/menu"
import { onItemsChange } from "tests/fixtures/items.ts"
import { changedMenuGroups, menuGroups } from "tests/fixtures/menu-groups.ts"

export default class Fixture extends Component {
  @tracked groups = menuGroups

  constructor(owner: Owner, args: object) {
    super(owner, args)
    const stop = onItemsChange(
      changedMenuGroups,
      (next) => (this.groups = next)
    )
    if (typeof stop === "function") {
      registerDestructor(this, stop)
    }
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <Menu as |m|>
        <m.Trigger>Actions</m.Trigger>
        <m.Content class="popup">
          {{#each this.groups key="label" as |group|}}
            <m.Group as |g|>
              <g.Label class="label">{{group.label}}</g.Label>
              {{#each group.items key="value" as |item|}}
                <m.Item
                  class="item"
                  @value={{item.value}}
                >{{item.label}}</m.Item>
              {{/each}}
            </m.Group>
          {{/each}}
        </m.Content>
      </Menu>
    </div>
  </template>
}
