import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  rating,
  type RatingController,
  type RatingValueChangeReason,
} from "@ui-sdk/core/rating"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import RatingItem from "./rating-item.gts"

/** A score picked from a row of stars, a radio per star or half star, with a preview while a pointer moves over them. Its content renders once per star, and yields each star's `Item`. */
class Rating extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The score. Pass it with `@onValueChange` to control the rating. */
    value?: number | null
    /** The score at first, when uncontrolled. A form reset returns to it. */
    defaultValue?: number | null
    /** How many stars there are. */
    max?: number
    /** The smallest step between scores, like 0.5 for half stars. */
    step?: number
    /** Whether pressing the current score clears it. */
    deselectable?: boolean
    /** Stops input. */
    disabled?: boolean
    /** Keeps it focusable and submitted, but presses don't change it. */
    readOnly?: boolean
    /** Blocks form submission until it has a score. */
    required?: boolean
    /** The name the score submits under. */
    name?: string
    /** The id of a form to belong to, when it isn't inside that form. */
    form?: string
    /** Whether arrow keys wrap from the last star to the first. */
    loop?: boolean
    /** Writes the score for screen readers. */
    getValueLabel?: (value: number, max: number) => string
    /** Drives the rating from anywhere. Create one with `createRatingController()`. */
    controller?: RatingController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when a score wants to change. `details.cancel()` stops it. */
    onValueChange?: (
      value: number | null,
      details: ChangeDetails<RatingValueChangeReason>
    ) => void
    /** Its id, which a Field's label points at. */
    id?: string
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  handle = usePrimitive(this, rating, () => ({
    max: this.max,
    step: this.step,
    disabled: this.args.disabled || this.fieldControl.disabled,
    name: this.args.name ?? this.fieldControl.name,
  }))
  root = usePart(this, () => this.handle, "root")

  get max() {
    return this.args.max ?? 5
  }

  get step() {
    return this.args.step ?? 1
  }

  get stars() {
    return Array.from({ length: this.max }, (_, at) => at + 1)
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash part=this.root.modifier state=this.root.state handle=this.handle)
      as |r|
    }}
      {{#if @render}}
        {{yield r}}
      {{else}}
        <div
          id={{@id}}
          ...attributes
          {{this.root.modifier}}
          {{this.fieldControl.modifier}}
        >
          {{#each this.stars key="@identity" as |index|}}
            {{#if (has-block)}}
              {{yield
                (hash
                  state=this.root.state
                  Item=(component
                    RatingItem handle=this.handle index=index step=this.step
                  )
                )
              }}
            {{else}}
              <RatingItem
                @handle={{this.handle}}
                @index={{index}}
                @step={{this.step}}
              />
            {{/if}}
          {{/each}}
        </div>
      {{/if}}
    {{/let}}
  </template>
}

export default Rating
