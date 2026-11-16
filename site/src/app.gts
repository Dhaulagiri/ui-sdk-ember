import { on } from "@ember/modifier"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import pages from "virtual:docs-nav"
import { enhance } from "./enhance.ts"
import { fill } from "./fill.ts"
import { parse } from "./markdown.ts"

const docs = import.meta.glob("../../docs/**/*.md", {
  query: "?raw",
  import: "default",
})

function readRoute() {
  const [path = "", anchor = ""] = location.hash.slice(1).split("#")
  return { path: path.replace(/^\/|\/$/g, "") || "index", anchor }
}

const groups = [...new Set(pages.map((page) => page.group))].map((group) => ({
  name: group,
  pages: pages
    .filter((page) => page.group === group)
    .map((page) => ({
      ...page,
      href: `#/${page.path === "index" ? "" : page.path}`,
    })),
}))

function render(
  element: HTMLElement,
  html: string,
  path: string,
  anchor: string
) {
  const cleanup = enhance(element, html, path)
  if (anchor) {
    document.getElementById(anchor)?.scrollIntoView()
  } else {
    window.scrollTo(0, 0)
  }
  return cleanup
}

export class App extends Component {
  @tracked route = readRoute()
  @tracked html = ""
  @tracked title = ""
  @tracked description = ""
  @tracked missing = false

  constructor(owner: Owner, args: object) {
    super(owner, args)
    window.addEventListener("hashchange", this.navigate)
    this.load()
  }

  willDestroy() {
    super.willDestroy()
    window.removeEventListener("hashchange", this.navigate)
  }

  navigate = () => {
    const next = readRoute()
    const samePage = next.path === this.route.path
    this.route = next
    if (samePage) {
      document.getElementById(next.anchor)?.scrollIntoView()
    } else {
      this.load()
    }
  }

  async load() {
    const { path } = this.route
    const load = docs[`../../docs/${path}.md`]
    if (!load) {
      this.missing = true
      this.html = ""
      document.title = "Not found | ember-ui-sdk"
      return
    }
    const page = parse((await load()) as string)
    if (path !== this.route.path) {
      return
    }
    this.missing = false
    this.title = page.title
    this.description =
      pages.find((entry) => entry.path === path)?.description ?? ""
    this.html = page.html
    document.title =
      path === "index" ? "ember-ui-sdk" : `${page.title} | ember-ui-sdk`
  }

  scrollToAnchor = (event: MouseEvent) => {
    const anchor = (event.target as HTMLElement).closest<HTMLElement>(
      "[data-anchor]"
    )?.dataset.anchor
    if (anchor) {
      event.preventDefault()
      document.getElementById(anchor)?.scrollIntoView()
    }
  }

  isCurrent = (path: string) => path === this.route.path

  <template>
    <a class="skip" href="#main">Skip to content</a>
    <header class="top">
      <a class="brand" href="#/">ember-ui-sdk</a>
      <nav aria-label="Links">
        <a href="https://github.com/Dhaulagiri/ui-sdk-ember">GitHub</a>
        <a href="https://www.npmjs.com/package/ember-ui-sdk">npm</a>
        <a href="https://ui-sdk.dev/docs">ui-sdk</a>
      </nav>
    </header>
    <div class="layout">
      <nav class="side" aria-label="Docs">
        {{#each groups as |group|}}
          <h2>{{group.name}}</h2>
          <ul>
            {{#each group.pages as |page|}}
              <li>
                <a
                  href={{page.href}}
                  aria-current={{if (this.isCurrent page.path) "page"}}
                >{{page.title}}</a>
              </li>
            {{/each}}
          </ul>
        {{/each}}
      </nav>
      {{! template-lint-disable no-invalid-interactive }}
      <main id="main" tabindex="-1" {{on "click" this.scrollToAnchor}}>
        {{#if this.missing}}
          <h1>Page not found</h1>
          <p><a href="#/">Back to the introduction</a></p>
        {{else}}
          <h1>{{this.title}}</h1>
          {{#if this.description}}<p
              class="lede"
            >{{this.description}}</p>{{/if}}
          <article
            {{fill render this.html this.route.path this.route.anchor}}
          ></article>
        {{/if}}
      </main>
    </div>
  </template>
}
