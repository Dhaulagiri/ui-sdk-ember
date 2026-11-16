import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { ChevronLeft, ChevronRight, Calendar, X } from "lucide"
import {
  DatePicker,
  createDatePickerController,
} from "ember-ui-sdk/date-picker"
import { icon } from "../../../shared/ember/icon"

export default class Controller extends Component {
  controller = createDatePickerController()

  choose = () => {
    this.controller.setValue("2026-12-25")
  }

  open = () => {
    this.controller.open()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.choose}}>Choose Christmas</button>
        <button type="button" {{on "click" this.open}}>Open</button>
      </div>
      <DatePicker
        @controller={{this.controller}}
        @defaultValue="2026-10-16"
        as |dp|
      >
        <div data-slot="row">
          <dp.Input aria-label="Due date" />
          <dp.Trigger data-variant="ghost">{{icon Calendar}}</dp.Trigger>
        </div>
        <dp.Hint />
        <dp.Content>
          <div data-slot="row">
            <dp.Previous data-variant="ghost">{{icon ChevronLeft}}</dp.Previous>
            <dp.Heading />
            <dp.Next data-variant="ghost">{{icon ChevronRight}}</dp.Next>
          </div>
          <dp.Grid />
        </dp.Content>
      </DatePicker>
    </div>
  </template>
}
