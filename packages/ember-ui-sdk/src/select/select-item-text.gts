import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { select } from "@ui-sdk/core/select"
import { onInsert } from "../on-insert"
import { afterRender } from "../use-primitive"
import { usePart, type PartSignature } from "../use-part"

/** Its item's text, which typeahead and the trigger read. Marks what a search matched. With `@render`, binds your own element with the yielded `part`, and its text is the item's label. */
class SelectItemText extends Component<
  PartSignature<
    typeof select,
    "item-text",
    HTMLSpanElement,
    { item: string; label?: string }
  >
> {
  // Read from the content once it's in the page, as Svelte does: a block
  // can't be read before it renders. Content that holds elements stays.
  @tracked text?: string
  showSegments = (hasBlock: boolean) => Boolean(this.text) || !hasBlock
  part = usePart(
    this,
    () => this.args.handle,
    "item-text",
    () => ({
      id: this.args.item,
      text: this.text ?? this.args.label ?? "",
    })
  )

  learn = (el: Element) => {
    if ([...el.childNodes].some((node) => node.nodeType === 1)) {
      return
    }
    const text = (el.textContent ?? "").replace(/\s+/g, " ").trim()
    afterRender(() => (this.text = text))
  }

  <template>
    {{~#if @render~}}
      {{~yield this.part.yielded~}}
    {{~else~}}
      <span ...attributes {{this.part.modifier}} {{onInsert this.learn}}>
        {{~#if (this.showSegments (has-block))~}}
          {{~#each this.part.state.segments as |segment|~}}
            {{~#if segment.match}}<mark
              >{{segment.text}}</mark>{{else}}{{segment.text}}{{/if~}}
          {{~/each~}}
        {{~else}}{{yield this.part.yielded}}{{/if~}}
      </span>
    {{~/if~}}
  </template>
}

export default SelectItemText
