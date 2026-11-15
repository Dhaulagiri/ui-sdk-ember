import Component from "@glimmer/component"
import { command } from "@ui-sdk/core/command"
import { usePart, type PartSignature } from "../use-part"
import CommandGroup from "./command-group.gts"
import CommandItem from "./command-item.gts"
import CommandSeparator from "./command-separator.gts"

/** Commands shown while this page is on top. Without `@value`, it's the first page. Renders no element. */
class CommandPage extends Component<
  PartSignature<typeof command, "page", HTMLElement>
> {
  get value() {
    return (this.args.value as string | undefined) ?? null
  }

  part = usePart(
    this,
    () => this.args.handle,
    "page",
    () => ({
      value: this.args.value,
    })
  )

  <template>
    {{#if this.part.present}}
      {{! @glint-expect-error a page yields its parts without a part modifier }}
      {{yield
        (hash
          Group=(component CommandGroup handle=@handle inPage=this.value)
          Item=(component CommandItem handle=@handle inPage=this.value)
          Separator=(component CommandSeparator handle=@handle)
        )
      }}
    {{/if}}
  </template>
}

export default CommandPage
