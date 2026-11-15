import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { NavigationMenu } from "ember-ui-sdk/navigation-menu"
import {
  exposeNavigationMenuValue,
  navigationMenuFixture as fixture,
  navigationMenuLayout,
} from "tests/fixtures/navigation-menu.ts"

export default class NavigationMenuBoundFixture extends Component {
  fixture = fixture
  layout = navigationMenuLayout()
  @tracked value: string | null = null
  @tracked completed: boolean[] = []

  constructor(owner: Owner, args: object) {
    super(owner, args)
    exposeNavigationMenuValue((next) => (this.value = next))
  }

  setValue = (next: string | null) => (this.value = next)
  onOpenChangeComplete = (open: boolean) => {
    this.completed = [...this.completed, open]
  }

  get completedText() {
    return this.completed.join(",")
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <NavigationMenu
        aria-label="Main"
        class="nav-menu"
        @delay={{0}}
        @closeDelay={{0}}
        @value={{this.value}}
        @onValueChange={{this.setValue}}
        @onOpenChangeComplete={{this.onOpenChangeComplete}}
        as |n|
      >
        <n.List class="nav-list" as |l|>
          {{#each this.fixture.items key="value" as |item|}}
            <l.Item @value={{item.value}} as |i|>
              <i.Trigger class="nav-trigger">{{item.trigger}}</i.Trigger>
              <i.Content class="nav-content" as |c|>
                <ul>
                  {{#each item.links key="href" as |link|}}
                    <li><c.Link href={{link.href}}>{{link.label}}</c.Link></li>
                  {{/each}}
                </ul>
              </i.Content>
            </l.Item>
          {{/each}}
        </n.List>
        {{#if this.layout.viewport}}<n.Viewport class="nav-viewport" />{{/if}}
      </NavigationMenu>
      <button>After</button>
      <output
        role="status"
        aria-label="Completed"
      >{{this.completedText}}</output>
    </div>
  </template>
}
