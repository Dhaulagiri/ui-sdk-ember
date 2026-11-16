import Component from "@glimmer/component"
import { htmlSafe } from "@ember/template"
import { ScrollArea } from "ember-ui-sdk/scroll-area"

const swatches = [
  { name: "Sand", color: "#e6d8bf" },
  { name: "Clay", color: "#c98b6b" },
  { name: "Rust", color: "#a4502f" },
  { name: "Moss", color: "#7d8b5a" },
  { name: "Sage", color: "#b5c2a3" },
  { name: "Fog", color: "#c9d1d6" },
  { name: "Slate", color: "#5b6b78" },
  { name: "Ink", color: "#2b2f36" },
]

export default class Horizontal extends Component {
  swatchStyle = (color: string) => htmlSafe(`background: ${color}`)

  <template>
    <ScrollArea @type="auto" as |s|>
      <s.Viewport role="region" aria-label="Palette">
        <s.Content>
          <ul>
            {{#each swatches key="name" as |swatch|}}
              <li>
                <div
                  data-slot="swatch"
                  style={{this.swatchStyle swatch.color}}
                ></div>
                {{swatch.name}}
              </li>
            {{/each}}
          </ul>
        </s.Content>
      </s.Viewport>
      <s.Scrollbar @orientation="horizontal" as |sb|>
        <sb.Thumb />
      </s.Scrollbar>
    </ScrollArea>
  </template>
}
