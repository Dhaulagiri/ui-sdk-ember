import type { ModifierLike } from "@glint/template"
import type { TOC } from "@ember/component/template-only"

const RouterLink: TOC<{
  Element: HTMLAnchorElement
  Args: { part: ModifierLike<{ Element: Element }> }
  Blocks: { default: [] }
}> = <template>
  <a {{@part}} ...attributes>{{yield}}</a>
</template>

const navigate = (event: MouseEvent) => {
  const link = (event.target as Element).closest("a[href]")
  if (!link || event.defaultPrevented) {
    return
  }
  event.preventDefault()
  history.pushState(null, "", link.getAttribute("href"))
}

export { navigate }
export default RouterLink
