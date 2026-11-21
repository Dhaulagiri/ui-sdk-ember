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
  // can't be read before it renders. Content that holds elements stays as
  // it is, and the label is what's marked. A reused item takes a new key,
  // so its text is read again.
  @tracked learned?: { item: string; text: string | undefined }

  get text() {
    return this.learned?.item === this.args.item ? this.learned.text : undefined
  }

  part = usePart(
    this,
    () => this.args.handle,
    "item-text",
    () => ({
      id: this.args.item,
      text: this.text ?? this.args.label ?? "",
    })
  )

  // A reused item or a count in its label changes the content without a new
  // block, so only the page can tell. While a search marks the text, the
  // marks stand in for the content.
  get searching() {
    return (
      this.text !== undefined &&
      this.part.state.segments.some((segment) => segment.match)
    )
  }

  showSegments = (hasBlock: boolean) => !hasBlock || this.searching

  // Without a block the element holds the marks themselves, and the label
  // is the text.
  learnFrom = (hasBlock: boolean) => (hasBlock ? this.learn : () => {})

  learn = (el: Element) => {
    const read = () => {
      if (this.searching) {
        return
      }
      const item = this.args.item
      const text = [...el.childNodes].some((node) => node.nodeType === 1)
        ? undefined
        : (el.textContent ?? "").replace(/\s+/g, " ").trim()
      if (this.learned?.item !== item || this.learned.text !== text) {
        afterRender(() => (this.learned = { item, text }))
      }
    }
    read()
    const observer = new MutationObserver(read)
    observer.observe(el, {
      childList: true,
      characterData: true,
      subtree: true,
    })
    return () => observer.disconnect()
  }

  <template>
    {{~#if @render~}}
      {{~yield this.part.yielded~}}
    {{~else~}}
      <span
        ...attributes
        {{this.part.modifier}}
        {{onInsert (this.learnFrom (has-block))}}
      >
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
