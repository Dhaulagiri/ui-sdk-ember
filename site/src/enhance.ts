import { mountExample } from "./example.ts"

const exampleLink = /examples\/components\/([\w-]+)\/ember\/([\w-]+)\.gts$/

function resolveDoc(path: string, href: string) {
  const base = path.split("/").slice(0, -1)
  const [file, hash] = href.split("#")
  for (const part of file.split("/")) {
    if (part === "..") {
      base.pop()
    } else if (part !== ".") {
      base.push(part)
    }
  }
  const target = base.join("/").replace(/\.md$/, "")
  return `#/${target === "index" ? "" : target}${hash ? `#${hash}` : ""}`
}

// Fills an article with a rendered page: examples mounted, links pointed at
// the site's routes. Returns what undoes it.
function enhance(article: HTMLElement, html: string, path: string) {
  article.innerHTML = html
  const cleanups: (() => void)[] = []

  for (const link of article.querySelectorAll<HTMLAnchorElement>("a[href]")) {
    const href = link.getAttribute("href")!
    const example = href.match(exampleLink)
    if (example && link.parentElement?.tagName === "P") {
      const host = document.createElement("div")
      link.parentElement.replaceWith(host)
      cleanups.push(mountExample(host, `${example[1]}/${example[2]}`))
    } else if (/^https?:/.test(href)) {
      link.target = "_blank"
      link.rel = "noopener noreferrer"
    } else if (href.startsWith("#")) {
      link.dataset.anchor = href.slice(1)
    } else if (/\.md(#|$)/.test(href)) {
      link.setAttribute("href", resolveDoc(path, href))
    }
  }

  return () => {
    for (const cleanup of cleanups) {
      cleanup()
    }
    article.replaceChildren()
  }
}

export { enhance }
