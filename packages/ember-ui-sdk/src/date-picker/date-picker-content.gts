import Component from "@glimmer/component"
import type { calendar } from "@ui-sdk/core/calendar"
import { datePicker } from "@ui-sdk/core/date-picker"
import { portalTarget } from "@ui-sdk/core/renderer"
import CalendarGrid from "../calendar/calendar-grid.gts"
import CalendarHeading from "../calendar/calendar-heading.gts"
import CalendarNext from "../calendar/calendar-next.gts"
import CalendarPrevious from "../calendar/calendar-previous.gts"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

type Container = Element | DocumentFragment | null | undefined

/** The popup. Without a block it renders Previous, the heading, Next and a grid for each month; every Calendar part works inside it. */
class DatePickerContent extends Component<
  PartSignature<
    typeof datePicker,
    "content",
    HTMLDivElement,
    { container?: Container; rootContainer?: Container; months?: number }
  >
> {
  viewport = usePart(this, () => this.args.handle, "viewport")
  part = usePart(this, () => this.args.handle, "content")

  get target() {
    return portalTarget(this.args.container ?? this.args.rootContainer)
  }

  get calendar() {
    return this.args.handle as unknown as PrimitiveHandle<typeof calendar>
  }

  get offsets() {
    const months = this.args.months
    return Array.from(
      { length: Math.max(1, Math.floor(months ?? 1) || 1) },
      (_, offset) => offset
    )
  }

  <template>
    {{#if this.part.present}}
      <Portal @to={{this.target}}>
        {{#if this.viewport.present}}
          <div {{this.viewport.modifier}}>
            {{#if @render}}
              {{yield this.part.yielded}}
            {{else}}
              <div ...attributes {{this.part.modifier}}>
                {{~#if (has-block)}}{{yield this.part.yielded}}{{else~}}
                  <div>
                    <CalendarPrevious @handle={{this.calendar}} />
                    <CalendarHeading @handle={{this.calendar}} />
                    <CalendarNext @handle={{this.calendar}} />
                  </div>
                  {{~#each this.offsets as |offset|~}}
                    <CalendarGrid
                      @handle={{this.calendar}}
                      @offset={{offset}}
                    />
                  {{~/each~}}
                {{~/if~}}
              </div>
            {{/if}}
          </div>
        {{else if @render}}
          {{yield this.part.yielded}}
        {{else}}
          <div ...attributes {{this.part.modifier}}>
            {{~#if (has-block)}}{{yield this.part.yielded}}{{else~}}
              <div>
                <CalendarPrevious @handle={{this.calendar}} />
                <CalendarHeading @handle={{this.calendar}} />
                <CalendarNext @handle={{this.calendar}} />
              </div>
              {{~#each this.offsets as |offset|~}}
                <CalendarGrid @handle={{this.calendar}} @offset={{offset}} />
              {{~/each~}}
            {{~/if~}}
          </div>
        {{/if}}
      </Portal>
    {{/if}}
  </template>
}

export default DatePickerContent
