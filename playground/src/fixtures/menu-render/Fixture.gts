import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Menu } from "ember-ui-sdk/menu"

const renders = { watched: 0, plain: 0 }
;(window as unknown as { __renders: typeof renders }).__renders = renders

const count = (key: "watched" | "plain", ..._reads: unknown[]) => (
  renders[key]++,
  ""
)

export default class Fixture extends Component {
  @tracked action = ""

  setAction = (value: string) => (this.action = value)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Menu @onAction={{this.setAction}} as |m|>
        <m.Trigger>File</m.Trigger>
        <m.Content class="popup">
          <m.Item @value="docs" @render={{true}} as |item|>
            <a class="item" href="#docs" {{item.part}}>Docs</a>
          </m.Item>
          <m.Item @value="watched" @render={{true}} as |item|>
            <div class="item" {{item.part}}>{{count
                "watched"
                item.state.highlighted
              }}{{if item.state.highlighted "→ "}}Watched</div>
          </m.Item>
          <m.Item @value="plain" @render={{true}} as |item|>
            <div class="item" {{item.part}}>{{count "plain"}}Plain</div>
          </m.Item>
          <m.CheckboxItem @value="pinned" class="item" as |item|>
            <span
              class={{if item.state.checked "is-checked" "is-unchecked"}}
            >Pinned</span>
          </m.CheckboxItem>
        </m.Content>
      </Menu>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
