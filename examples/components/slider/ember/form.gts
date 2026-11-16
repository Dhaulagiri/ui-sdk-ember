import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { array } from "@ember/helper"
import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"
import { useLog } from "../../../shared/ember/log"

const distance = { style: "unit", unit: "kilometer" } as const

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = [...new FormData(event.currentTarget as HTMLFormElement)].map(
      ([name, value]) => `${name}=${value}`
    )
    this.log(`Submitted ${data.join(", ")}`)
  }

  <template>
    <div data-slot="stack">
      <form id="slider-form" data-slot="stack" {{on "submit" this.onSubmit}}>
        <Field as |f|>
          <Slider
            @name="price"
            @defaultValue={{array 200 800}}
            @max={{1000}}
            @step={{10}}
            @field={{f.field}}
            as |s|
          >
            <div data-slot="row">
              <f.Label>Price</f.Label>
              <s.Value />
            </div>
            <s.Control>
              <s.Track>
                <s.Indicator />
                <s.Thumb @index={{0}} aria-label="Minimum price" />
                <s.Thumb @index={{1}} aria-label="Maximum price" />
              </s.Track>
            </s.Control>
          </Slider>
        </Field>
        <Field as |f|>
          <Slider
            @name="rating"
            @defaultValue={{3}}
            @min={{1}}
            @max={{5}}
            @field={{f.field}}
            as |s|
          >
            <div data-slot="row">
              <f.Label>Minimum rating</f.Label>
              <s.Value />
            </div>
            <s.Control>
              <s.Track>
                <s.Indicator />
                <s.Thumb />
              </s.Track>
            </s.Control>
          </Slider>
        </Field>
      </form>
      <Field as |f|>
        <Slider
          @name="distance"
          @form="slider-form"
          @defaultValue={{25}}
          @max={{100}}
          @step={{5}}
          @format={{distance}}
          @field={{f.field}}
          as |s|
        >
          <div data-slot="row">
            <f.Label>Distance</f.Label>
            <s.Value />
          </div>
          <s.Control>
            <s.Track>
              <s.Indicator />
              <s.Thumb />
            </s.Track>
          </s.Control>
        </Slider>
      </Field>
      <div data-slot="row">
        <button
          type="submit"
          form="slider-form"
          data-variant="solid"
        >Save</button>
        <button type="reset" form="slider-form">Reset</button>
      </div>
    </div>
  </template>
}
