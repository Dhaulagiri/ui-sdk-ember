import { renderComponent } from "@ember/renderer"

const modules = import.meta.glob("../../examples/components/*/ember/*.gts")
const sources = import.meta.glob("../../examples/components/*/ember/*.gts", {
  query: "?raw",
  import: "default",
})

function element<K extends keyof HTMLElementTagNameMap>(
  tag: K,
  attributes: Record<string, string> = {},
  text = ""
) {
  const node = document.createElement(tag)
  for (const [name, value] of Object.entries(attributes)) {
    node.setAttribute(name, value)
  }
  node.textContent = text
  return node
}

function mountExample(host: HTMLElement, name: string) {
  const [component, file] = name.split("/")
  const key = `../../examples/components/${component}/ember/${file}.gts`
  let destroyed = false
  let destroy = () => {}

  const frame = element("figure", { class: "example" })
  const bar = element("div", { class: "example-bar" })
  const label = element("span", {}, `${name}.gts`)
  const preview = element("button", { type: "button", "aria-pressed": "true" })
  preview.textContent = "Preview"
  const code = element("button", { type: "button", "aria-pressed": "false" })
  code.textContent = "Code"
  bar.append(label, preview, code)

  const stage = element("div", { class: "example-stage", "data-example": "" })
  const pre = element("pre", { class: "example-code", hidden: "" })
  const log = element("ol", {
    class: "example-log",
    "aria-label": "Console",
    hidden: "",
  })
  frame.append(bar, stage, pre, log)
  host.replaceChildren(frame)

  const show = (view: "preview" | "code") => {
    stage.hidden = view !== "preview"
    pre.hidden = view !== "code"
    preview.setAttribute("aria-pressed", String(view === "preview"))
    code.setAttribute("aria-pressed", String(view === "code"))
  }
  preview.addEventListener("click", () => show("preview"))
  code.addEventListener("click", () => show("code"))

  const append = (message: string) => {
    log.hidden = false
    log.append(element("li", {}, message))
    log.scrollTop = log.scrollHeight
  }

  Promise.all([modules[key](), sources[key]()])
    .then(([module, source]) => {
      if (destroyed) {
        return
      }
      pre.append(element("code", {}, String(source)))
      const result = renderComponent((module as { default: object }).default, {
        into: stage,
        owner: { log: append },
      })
      destroy = () => result.destroy()
    })
    .catch((error) => {
      stage.textContent = `Could not load this example: ${error}`
      console.error(error)
    })

  return () => {
    destroyed = true
    destroy()
    host.replaceChildren()
  }
}

export { mountExample }
