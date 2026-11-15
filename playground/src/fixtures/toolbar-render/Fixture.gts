import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Toolbar } from "ember-ui-sdk/toolbar"

const renders: Record<string, number> = {}
;(window as unknown as { __renders: typeof renders }).__renders = renders
const counted = (name: string) => {
  renders[name] = (renders[name] ?? 0) + 1
  return name
}
const availability = (disabled: boolean) =>
  disabled ? "is-disabled" : "is-enabled"

export default class ToolbarRenderFixture extends Component {
  @tracked action = ""

  span = () => (this.action = "span")
  cut = () => (this.action = "cut")
  copy = () => (this.action = "copy")

  <template>
    <div class="fixture">
      <button>Before</button>
      <Toolbar class="toolbar" aria-label="Tools" as |t|>
        <t.Button @render={{true}} as |b|>
          <span {{b.part}} {{on "click" this.span}}>{{counted
              "Span tool"
            }}</span>
        </t.Button>
        <t.Button {{on "click" this.cut}}>{{counted "Cut"}}</t.Button>
        <t.Button {{on "click" this.copy}}>{{counted "Copy"}}</t.Button>
        <t.Separator class="rule" @render={{true}} as |s|>
          <hr {{s.part}} />
        </t.Separator>
        <t.Button @disabled={{true}} @render={{true}} as |b|>
          <a {{b.part}} href="#old" class={{availability b.state.disabled}}>Old
            docs</a>
        </t.Button>
      </Toolbar>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
