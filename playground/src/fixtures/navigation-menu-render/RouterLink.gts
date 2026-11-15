import type { ModifierLike } from "@glint/template"
import { fn } from "@ember/helper"
import type { TOC } from "@ember/component/template-only"
import { on } from "@ember/modifier"

const navigate = (to: string, event: MouseEvent) => {
  event.preventDefault()
  history.pushState(null, "", to)
}

const RouterLink: TOC<{
  Element: HTMLAnchorElement
  Args: { to: string; part: ModifierLike<{ Element: Element }> }
  Blocks: { default: [] }
}> = <template>
  <a
    href={{@to}}
    ...attributes
    {{@part}}
    {{on "click" (fn navigate @to)}}
  >{{yield}}</a>
</template>

export default RouterLink
