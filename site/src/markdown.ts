import { Marked } from "marked"

const marked = new Marked({
  gfm: true,
  renderer: {
    heading({ tokens, depth, text }) {
      const id = slug(text)
      return `<h${depth} id="${id}">${this.parser.parseInline(tokens)}</h${depth}>\n`
    },
  },
})

function slug(text: string) {
  return text
    .toLowerCase()
    .replace(/[^\w\s-]/g, "")
    .trim()
    .replace(/\s+/g, "-")
}

function parse(source: string) {
  const match = source.match(/^---\n([^]*?)\n---\n/)
  const body = match ? source.slice(match[0].length) : source
  const title = match?.[1].match(/^title: (.*)$/m)?.[1] ?? ""
  return { title, html: marked.parse(body, { async: false }) }
}

export { parse, slug }
