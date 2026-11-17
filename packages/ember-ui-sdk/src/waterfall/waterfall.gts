import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { waterfall, type WaterfallOptions } from "@ui-sdk/core/waterfall"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import WaterfallAxis from "./waterfall-axis.gts"
import WaterfallBar from "./waterfall-bar.gts"
import WaterfallColumnHeader from "./waterfall-column-header.gts"
import WaterfallHeaderRow from "./waterfall-header-row.gts"
import WaterfallIndicator from "./waterfall-indicator.gts"
import WaterfallMark from "./waterfall-mark.gts"
import WaterfallRow from "./waterfall-row.gts"
import WaterfallRowHeader from "./waterfall-row-header.gts"

/** A trace's spans on a shared time axis, as a tree of rows you expand and collapse, with one tab stop. Without a block, it renders a row for every span. Yields its parts. */
class Waterfall extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The spans, as a tree. */
    items: unknown[]
    /** The times the axis spans, `[start, end]`. Defaults to the spans' own. */
    range?: [number, number]
    /** The selected span. Pass it with `@onValueChange` to control it. */
    value?: string | null
    /** The selected span at first, when uncontrolled. */
    defaultValue?: string | null
    /** The expanded spans. Pass it with `@onExpandedChange` to control them. */
    expanded?: string[]
    /** The expanded spans at first, when uncontrolled. */
    defaultExpanded?: string[]
    /** How times read: `Intl.NumberFormat` options, or a function of the time. */
    format?: unknown
    /** The locale times are formatted in. */
    locale?: string
    /** Writes a bar's label for screen readers. */
    getBarLabel?: WaterfallOptions["getBarLabel"]
    /** Expands, collapses and selects from anywhere. */
    controller?: object
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when the selection wants to change. `details.cancel()` stops it. */
    onValueChange?: WaterfallOptions["onValueChange"]
    /** Runs when spans want to expand or collapse. `details.cancel()` stops it. */
    onExpandedChange?: WaterfallOptions["onExpandedChange"]
    /** Runs when the highlighted span changes. */
    onHighlight?: WaterfallOptions["onHighlight"]
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, waterfall)
  root = usePart(this, () => this.handle, "root")

  get spans() {
    this.args.items
    return this.handle.api.internal.all() as {
      value: string
      label: string
      children?: unknown[]
    }[]
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        HeaderRow=(component WaterfallHeaderRow handle=this.handle)
        ColumnHeader=(component WaterfallColumnHeader handle=this.handle)
        Axis=(component WaterfallAxis handle=this.handle)
        Mark=(component WaterfallMark handle=this.handle)
        Row=(component WaterfallRow handle=this.handle)
      )
      as |w|
    }}
      {{#if @render}}
        {{yield w}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>
          {{~#if (has-block)}}{{yield w}}{{else}}
            {{~#each this.spans key="value" as |span|~}}
              <WaterfallRow @handle={{this.handle}} @value={{span.value}}>
                {{~!~}}
                <WaterfallRowHeader
                  @handle={{this.handle}}
                  @value={{span.value}}
                >
                  {{~#if span.children}}<WaterfallIndicator
                      @handle={{this.handle}}
                      @value={{span.value}}
                    />{{/if~}}
                  {{span.label}}
                </WaterfallRowHeader>
                {{~!~}}
                <WaterfallBar @handle={{this.handle}} @value={{span.value}} />
                {{~!~}}
              </WaterfallRow>
            {{~/each~}}
          {{/if~}}
        </div>
      {{/if}}
    {{/let}}
  </template>
}

export default Waterfall
