import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { NavigationMenu } from "ember-ui-sdk/navigation-menu"
import {
  navigationMenuAction,
  navigationMenuFixture as fixture,
  navigationMenuLayout,
  navigationMenuOptions,
} from "tests/fixtures/navigation-menu.ts"

export default class NavigationMenuFixture extends Component {
  fixture = fixture
  options = navigationMenuOptions()
  layout = navigationMenuLayout()
  @tracked action = ""

  get listClass() {
    return this.options.orientation === "vertical"
      ? "nav-list vertical"
      : "nav-list"
  }

  contentClass = (index: number) =>
    index === 0 ? "nav-content" : "nav-content narrow"
  nestedHere = (index: number) => index === 1 && this.layout.nested

  report = (value: string | null, { reason }: { reason: string }) => {
    this.action = navigationMenuAction(value, reason)
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <NavigationMenu
        aria-label="Main"
        class="nav-menu"
        @delay={{this.options.delay}}
        @closeDelay={{this.options.closeDelay}}
        @defaultValue={{this.options.defaultValue}}
        @orientation={{this.options.orientation}}
        @openOnHover={{this.options.openOnHover}}
        @closeOnSelect={{this.options.closeOnSelect}}
        @container={{this.options.container}}
        @onValueChange={{this.report}}
        as |n|
      >
        <n.List class={{this.listClass}} as |l|>
          {{#each this.fixture.items key="value" as |item index|}}
            <l.Item @value={{item.value}} as |i|>
              <i.Trigger class="nav-trigger">{{item.trigger}}</i.Trigger>
              <i.Content
                class={{this.contentClass index}}
                @keepMounted={{this.layout.keepMounted}}
                @hiddenUntilFound={{this.layout.hiddenUntilFound}}
                @side={{this.layout.placement.side}}
                @align={{this.layout.placement.align}}
                as |c|
              >
                <ul>
                  {{#each item.links key="href" as |link|}}
                    <li><c.Link href={{link.href}}>{{link.label}}</c.Link></li>
                  {{/each}}
                </ul>
                {{#if (this.nestedHere index)}}
                  <c.Menu @orientation="vertical" as |m|>
                    <m.List class="nav-list vertical" as |ml|>
                      <ml.Item @value={{this.fixture.nested.value}} as |mi|>
                        <mi.Trigger
                          class="nav-trigger"
                        >{{this.fixture.nested.trigger}}</mi.Trigger>
                        <mi.Content class="nav-content narrow" as |mc|>
                          <ul>
                            {{#each
                              this.fixture.nested.links key="href"
                              as |link|
                            }}
                              <li><mc.Link
                                  href={{link.href}}
                                >{{link.label}}</mc.Link></li>
                            {{/each}}
                          </ul>
                        </mi.Content>
                      </ml.Item>
                    </m.List>
                  </c.Menu>
                {{/if}}
              </i.Content>
            </l.Item>
          {{/each}}
          <l.Item as |i|>
            <i.Link
              class="nav-link"
              href={{this.fixture.link.href}}
              @current={{true}}
            >{{this.fixture.link.label}}</i.Link>
          </l.Item>
        </n.List>
        <n.Indicator class="nav-indicator" />
        {{#if this.layout.viewport}}
          <n.Viewport
            class="nav-viewport"
            @side={{this.layout.placement.side}}
            @align={{this.layout.placement.align}}
          />
        {{/if}}
      </NavigationMenu>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
