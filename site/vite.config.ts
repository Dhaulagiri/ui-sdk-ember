import { readdirSync, readFileSync } from "node:fs"
import { resolve } from "node:path"
import { fileURLToPath } from "node:url"
import { defineConfig, type Plugin } from "vite"
import { ember } from "../playground/ember-plugin.ts"

const docsRoot = resolve(import.meta.dirname, "../docs")
const groups = ["Get started", "Build your own", "Components"]

function frontmatter(file: string) {
  const text = readFileSync(file, "utf8")
  const field = (name: string) =>
    text.match(new RegExp(`^${name}: (.*)$`, "m"))?.[1] ?? ""
  return { title: field("title"), description: field("description") }
}

function docsNav(): Plugin {
  const id = "virtual:docs-nav"
  return {
    name: "docs-nav",
    resolveId: (source) => (source === id ? `\0${id}` : undefined),
    load(loaded) {
      if (loaded !== `\0${id}`) {
        return
      }
      const pages = (dir: string, group: string) =>
        readdirSync(resolve(docsRoot, dir))
          .filter((file) => file.endsWith(".md"))
          .sort()
          .map((file) => {
            const path = [dir, file.slice(0, -3)].filter(Boolean).join("/")
            return { path, group, ...frontmatter(resolve(docsRoot, dir, file)) }
          })
      const start = pages("", groups[0]).filter(
        (page) => page.path === "index" || page.path === "installation"
      )
      const own = [
        ...pages("", groups[1]).filter((page) => page.path === "rendering"),
        ...pages("utilities", groups[1]),
      ]
      const components = pages("components", groups[2]).sort(
        (a, b) =>
          Number(b.path.endsWith("/index")) - Number(a.path.endsWith("/index"))
      )
      return `export default ${JSON.stringify([...start, ...own, ...components])}`
    },
    configureServer(server) {
      server.watcher.add(docsRoot)
    },
  }
}

// ember-a2ui compiles like an app file, so Vite doesn't prebundle what's
// under it. Of that, only validate-color is CommonJS: it's wrapped as a module
// with a default export, the way @a2ui/web_core imports it.
function commonJsUnderA2ui(): Plugin {
  return {
    name: "a2ui-commonjs",
    transform(code, id) {
      if (!/\/validate-color\/lib\/index\.js$/.test(id.split("?")[0]!)) {
        return
      }
      return [
        "const module = { exports: {} }",
        code,
        "const exported = module.exports",
        "export default exported.__esModule ? exported.default : exported",
      ].join("\n")
    },
  }
}

// The base path is set per deploy: BASE_PATH=/ui-sdk-ember/ for GitHub Pages.
export default defineConfig({
  base: process.env.BASE_PATH ?? "/",
  plugins: [docsNav(), ember(), commonJsUnderA2ui()],
  // App examples also use the decorator transform's runtime.
  resolve: {
    alias: {
      "decorator-transforms/runtime": fileURLToPath(
        import.meta.resolve("decorator-transforms/runtime")
      ),
    },
  },
  optimizeDeps: {
    exclude: ["ember-ui-sdk", "ember-a2ui"],
    include: ["decorator-transforms/runtime", "lucide"],
  },
  server: { fs: { allow: [resolve(import.meta.dirname, "..")] } },
})
