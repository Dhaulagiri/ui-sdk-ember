import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"
import { useLog } from "../../../shared/ember/log"

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = new FormData(event.currentTarget as HTMLFormElement)
    this.log(`Saved theme=${data.get("theme")}, density=${data.get("density")}`)
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <f.Label>Theme</f.Label>
        <SegmentedControl
          @name="theme"
          @required={{true}}
          @defaultValue="system"
          @field={{f.field}}
          as |s|
        >
          <s.Indicator />
          <s.Item @value="light">Light</s.Item>
          <s.Item @value="dark">Dark</s.Item>
          <s.Item @value="system">System</s.Item>
        </SegmentedControl>
        <f.Description>System follows your device's setting.</f.Description>
      </Field>
      <Field as |f|>
        <f.Label>Density</f.Label>
        <SegmentedControl
          @name="density"
          @defaultValue="comfortable"
          @field={{f.field}}
          as |s|
        >
          <s.Indicator />
          <s.Item @value="compact">Compact</s.Item>
          <s.Item @value="comfortable">Comfortable</s.Item>
        </SegmentedControl>
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Save</button>
        <button type="reset">Reset</button>
      </div>
    </form>
  </template>
}
