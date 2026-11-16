import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Select } from "ember-ui-sdk/select"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { Check, ChevronsUpDown, ZoomIn, ZoomOut } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const zooms = ["50%", "75%", "100%", "150%", "200%"]

export default class SelectExample extends Component {
  log = useLog(this)
  @tracked zoom = "100%"

  get index() {
    return zooms.indexOf(this.zoom)
  }

  get atStart() {
    return this.index === 0
  }

  get atEnd() {
    return this.index === zooms.length - 1
  }

  change = (value: string) => {
    this.zoom = value
    this.log(`Zoom ${value}`)
  }

  zoomOut = () => this.change(zooms[this.index - 1])
  zoomIn = () => this.change(zooms[this.index + 1])

  onValueChange = (value: string | null) => {
    if (value) {
      this.change(value)
    }
  }

  <template>
    <Toolbar aria-label="View" as |t|>
      <t.Button
        aria-label="Zoom out"
        @disabled={{this.atStart}}
        {{on "click" this.zoomOut}}
      >
        {{icon ZoomOut}}
      </t.Button>
      <Select @value={{this.zoom}} @onValueChange={{this.onValueChange}} as |s|>
        <t.Button aria-label="Zoom" @render={{true}} as |b|>
          <s.Trigger @render={{true}} as |tr|>
            <button {{b.part}} {{tr.part}}>
              <s.Value />
              {{icon ChevronsUpDown}}
            </button>
          </s.Trigger>
        </t.Button>
        <s.Content>
          {{#each zooms key="@identity" as |zoom|}}
            <s.Item @value={{zoom}} as |item|>
              {{zoom}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
      <t.Button
        aria-label="Zoom in"
        @disabled={{this.atEnd}}
        {{on "click" this.zoomIn}}
      >
        {{icon ZoomIn}}
      </t.Button>
    </Toolbar>
  </template>
}
