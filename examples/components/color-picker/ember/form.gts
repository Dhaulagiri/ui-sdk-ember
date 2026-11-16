import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { ColorPicker } from "ember-ui-sdk/color-picker"
import { useLog } from "../../../shared/ember/log"

export default class Form extends Component {
  log = useLog(this)

  submit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Submitted brand=${new FormData(event.currentTarget as HTMLFormElement).get("brand")}`
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.submit}}>
      <Field as |f|>
        <f.Label>Brand color</f.Label>
        <ColorPicker
          @name="brand"
          @defaultValue="#f97316"
          @field={{f.field}}
          as |c|
        >
          <c.Area as |a|>
            <a.Thumb />
          </c.Area>
          <div data-slot="row">
            <c.Swatch />
            <c.Slider @channel="hue" as |s|>
              <s.Thumb />
            </c.Slider>
          </div>
        </ColorPicker>
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Save</button>
        <button type="reset">Reset</button>
      </div>
    </form>
  </template>
}
