import { OTPInput } from "ember-ui-sdk/otp-input"

<template>
  <OTPInput @maxLength={{5}} aria-label="Invite code" as |o|>
    <o.Group>
      {{#each o.state.slots as |slot index|}}
        <o.Slot @index={{index}} @render={{true}} as |s|>
          <span {{s.part}}>
            {{#if s.state.char}}
              {{s.state.char}}
            {{else if s.state.hasFakeCaret}}
              <span></span>
            {{/if}}
          </span>
        </o.Slot>
      {{/each}}
    </o.Group>
  </OTPInput>
</template>
