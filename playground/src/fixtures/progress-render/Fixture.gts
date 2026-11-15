import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Avatar } from "ember-ui-sdk/avatar"
import { OTPInput } from "ember-ui-sdk/otp-input"
import { Progress } from "ember-ui-sdk/progress"

const gaugeClass = (value: number) =>
  `gauge is-${value >= 100 ? "complete" : "progressing"}`
const slotClass = (active: boolean) => (active ? "is-active" : "")
const fallbackClass = (status: string) => `is-${status}`
const char = (value: string | null | undefined) => value ?? "·"

export default class ProgressRenderFixture extends Component {
  slots = [0, 1, 2, 3]
  @tracked value = 40

  finish = () => (this.value = 100)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Progress @value={{this.value}} @render={{true}} as |p|>
        <section {{p.part}} aria-label="Export" class={{gaugeClass this.value}}>
          <p.Value as |v|>{{v.state.percent}}% done</p.Value>
          <p.Track class="gauge-track">
            <p.Indicator
              class="gauge-indicator"
              data-status={{p.state.status}}
            />
          </p.Track>
        </section>
      </Progress>
      <Avatar @render={{true}} as |a|>
        <div {{a.part}} class="avatar">
          <a.Fallback class="avatar-fallback" as |f|>
            <span class={{fallbackClass f.state.loadingStatus}}>RF</span>
          </a.Fallback>
        </div>
      </Avatar>
      <OTPInput @ariaLabel="PIN" @maxLength={{4}} @render={{true}} as |o|>
        <section {{o.part}} class="otp">
          {{#each this.slots key="@identity" as |index|}}
            <o.Slot @index={{index}} class="otp-slot" as |s|>
              <span class={{slotClass s.state.active}}>{{char
                  s.state.char
                }}</span>
            </o.Slot>
          {{/each}}
          <o.Input />
        </section>
      </OTPInput>
      <button {{on "click" this.finish}}>Finish</button>
      <button>After</button>
      <output role="status" aria-label="Last action"></output>
    </div>
  </template>
}
