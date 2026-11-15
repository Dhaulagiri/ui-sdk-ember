import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { NavigationMenu } from "ember-ui-sdk/navigation-menu"
import RouterLink from "./RouterLink.gts"

export default class Fixture extends Component {
  @tracked action = ""

  onValueChange = (value: string | null, { reason }: { reason: string }) => {
    this.action = `${value ?? "close"}: ${reason}`
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <NavigationMenu
        aria-label="Docs"
        class="nav-menu"
        @onValueChange={{this.onValueChange}}
        as |n|
      >
        <n.List class="nav-list" as |l|>
          <l.Item @value="guides" as |i|>
            <i.Trigger @render={{true}} as |t|>
              <button
                class="nav-trigger {{if t.state.open 'is-open' 'is-closed'}}"
                {{t.part}}
              >
                Guides
                <span aria-hidden="true">{{if t.state.open "▲" "▼"}}</span>
              </button>
            </i.Trigger>
            <i.Content @render={{true}} aria-label="Guides panel" as |c|>
              <section class="nav-content" aria-label="Guides panel" {{c.part}}>
                <c.Link @current={{true}} @render={{true}} as |link|>
                  <RouterLink
                    @to="#intro"
                    @part={{link.part}}
                  >Introduction</RouterLink>
                </c.Link>
                <c.Link @render={{true}} as |link|>
                  <RouterLink
                    @to="#install"
                    @part={{link.part}}
                  >Install</RouterLink>
                </c.Link>
              </section>
            </i.Content>
          </l.Item>
        </n.List>
        <n.Viewport class="nav-viewport" />
      </NavigationMenu>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
