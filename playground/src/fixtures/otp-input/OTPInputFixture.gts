import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ChangeDetails } from "@ui-sdk/core"
import { createOTPInputController, OTPInput } from "ember-ui-sdk/otp-input"
import {
  otpInputAction,
  otpInputFixture,
  otpInputOptions,
} from "tests/fixtures/otp-input.ts"

const { code, recovery, form: formLabels } = otpInputFixture
const range = (start: number, length: number) =>
  Array.from({ length }, (_, index) => start + index)

export default class OTPInputFixture extends Component {
  controller = createOTPInputController()
  options = otpInputOptions()
  code = code
  recovery = recovery
  form = formLabels
  recoverySlots = range(0, recovery.length)
  groups = code.groups.map((size, group) => ({
    group,
    separated: group > 0,
    slots: range(
      code.groups.slice(0, group).reduce((sum, count) => sum + count, 0),
      size
    ),
  }))
  @tracked action = ""
  @tracked submitted = ""

  onValueChange = (value: string, details: ChangeDetails) => {
    if (this.options.cancel && value.includes(this.options.cancel)) {
      return details.cancel()
    }
    this.action = otpInputAction.change(value, details.reason)
  }

  onValueCommit = (value: string) => {
    this.action = otpInputAction.complete(value)
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = String(
      new FormData(event.currentTarget as HTMLFormElement).get(code.name)
    )
  }

  fill = () => this.controller.setValue(otpInputFixture.filled)
  clear = () => this.controller.clear()

  <template>
    <div class="fixture">
      <button>Before</button>
      <form aria-label={{this.form.label}} {{on "submit" this.onSubmit}}>
        <OTPInput
          class="otp"
          @ariaLabel={{this.code.label}}
          @name={{this.code.name}}
          @maxLength={{this.code.length}}
          @controller={{this.controller}}
          @defaultValue={{this.options.defaultValue}}
          @disabled={{this.options.disabled}}
          @required={{this.options.required}}
          @onValueChange={{this.onValueChange}}
          @onValueCommit={{this.onValueCommit}}
          as |o|
        >
          {{#each this.groups key="group" as |group|}}
            {{#if group.separated}}
              <o.Separator class="otp-separator">-</o.Separator>
            {{/if}}
            <o.Group class="otp-group">
              {{#each group.slots key="@identity" as |slot|}}
                <o.Slot @index={{slot}} class="otp-slot" />
              {{/each}}
            </o.Group>
          {{/each}}
        </OTPInput>
        <button type="submit">{{this.form.submit}}</button>
        <button type="reset">{{this.form.reset}}</button>
      </form>
      <OTPInput
        class="otp"
        @ariaLabel={{this.recovery.label}}
        @maxLength={{this.recovery.length}}
        @pattern="alphanumeric"
        as |o|
      >
        <o.Group class="otp-group">
          {{#each this.recoverySlots key="@identity" as |slot|}}
            <o.Slot @index={{slot}} class="otp-slot" />
          {{/each}}
        </o.Group>
      </OTPInput>
      <button {{on "click" this.fill}}>Fill code</button>
      <button {{on "click" this.clear}}>Clear code</button>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
