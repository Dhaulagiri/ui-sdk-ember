import { not, or } from "@ember/helper"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { combobox } from "@ui-sdk/core/combobox"
import { onInsert } from "../on-insert"
import { afterRender } from "../use-primitive"
import { usePart, type PartSignature } from "../use-part"

/** Its item's text, which filtering reads. Marks what the query matched. */
class ComboboxItemText extends Component<
  PartSignature<
    typeof combobox,
    "item-text",
    HTMLSpanElement,
    { item: string; label?: string }
  >
> {
  // Read from the content once it's in the page, as Svelte does: a block
  // can't be read before it renders. Content that holds elements stays.
  @tracked text?: string
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
    <span ...attributes {{this.part.modifier}} {{onInsert this.learn}}>
      {{~! @glint-expect-error the helper types lack a call signature ~}}
      {{~#if (or this.text (not (has-block)))~}}
        {{~#each this.part.state.segments as |segment|~}}
          {{~#if segment.match}}<mark
            >{{segment.text}}</mark>{{else}}{{segment.text}}{{/if~}}
        {{~/each~}}
      {{~else}}{{yield this.part.yielded}}{{/if~}}
    </span>
  </template>
}

export default ComboboxItemText
