import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"

<template>
  <Field as |f|>
    <Slider @defaultValue={{60}} @field={{f.field}} as |s|>
      <div data-slot="row">
        <f.Label>Brightness</f.Label>
        <s.Value as |v|>{{v.state.text}}%</s.Value>
      </div>
      <s.Control>
        <s.Track>
          <s.Indicator />
          <s.Thumb @render={{true}} as |t|>
            <span {{t.part}}>
              <span data-slot="output">{{t.state.thumbValue}}</span>
            </span>
          </s.Thumb>
        </s.Track>
      </s.Control>
    </Slider>
  </Field>
</template>
