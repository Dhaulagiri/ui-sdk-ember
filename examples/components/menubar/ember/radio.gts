import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Menubar } from "ember-ui-sdk/menubar"

const profiles = [
  { value: "hollis", label: "Hollis" },
  { value: "ines", label: "Inès" },
  { value: "kofi", label: "Kofi" },
]

const themes = [
  { value: "light", label: "Light" },
  { value: "dark", label: "Dark" },
  { value: "system", label: "System" },
]

export default class Radio extends Component {
  profiles = profiles
  themes = themes
  @tracked theme = "system"

  onThemeChange = (next: string | null) => {
    if (next) this.theme = next
  }

  <template>
    <div data-slot="stack">
      <Menubar as |mb|>
        <mb.Menu as |m|>
          <m.Trigger>Profiles</m.Trigger>
          <m.Content>
            <m.RadioGroup @defaultValue="ines" as |r|>
              {{#each this.profiles key="value" as |profile|}}
                <r.Item @value={{profile.value}} as |item|>
                  <item.Indicator />
                  {{profile.label}}
                </r.Item>
              {{/each}}
            </m.RadioGroup>
          </m.Content>
        </mb.Menu>
        <mb.Menu as |m|>
          <m.Trigger>Theme</m.Trigger>
          <m.Content>
            <m.RadioGroup
              @value={{this.theme}}
              @onValueChange={{this.onThemeChange}}
              as |r|
            >
              {{#each this.themes key="value" as |option|}}
                <r.Item @value={{option.value}} as |item|>
                  <item.Indicator />
                  {{option.label}}
                </r.Item>
              {{/each}}
            </m.RadioGroup>
          </m.Content>
        </mb.Menu>
      </Menubar>
      <output data-slot="output">Theme: {{this.theme}}</output>
    </div>
  </template>
}
