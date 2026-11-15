import { readFileSync } from "node:fs"
import { createRequire } from "node:module"
import { resolve } from "node:path"
import { defineConfig, type Plugin } from "vite"
import { ember } from "./ember-plugin.ts"

const require = createRequire(import.meta.url)

// The files the fixtures import from vendor/ui have no node_modules beside
// them, so their @ui-sdk/core imports resolve from the playground.
const vendorCore: Plugin = {
  name: "vendor-core",
  async resolveId(id, importer, options) {
    if (id.startsWith("@ui-sdk/core") && importer?.includes("/vendor/ui/")) {
      return this.resolve(
        id,
        resolve(import.meta.dirname, "src/main.ts"),
        options
      )
    }
  },
}

// A dependency found mid-run is bundled and reloads the page, which fails
// whichever spec is open, so every entry of core is bundled up front.
const coreEntries = Object.keys(
  JSON.parse(readFileSync(require.resolve("@ui-sdk/core/package.json"), "utf8"))
    .exports
)
  .filter(
    (key) =>
      !key.includes("*") && !key.endsWith(".css") && key !== "./package.json"
  )
  .map((key) => `@ui-sdk/core${key.slice(1)}`)

// The fixtures share their data and helpers with ui-sdk's specs, which live in
// the vendor/ui submodule, so "tests/..." resolves there.
export default defineConfig({
  plugins: [vendorCore, ember()],
  resolve: {
    alias: { tests: resolve(import.meta.dirname, "../vendor/ui/tests") },
  },
  optimizeDeps: {
    include: [
      ...coreEntries,
      "decorator-transforms/runtime",
      "@guidepup/virtual-screen-reader",
    ],
  },
  server: { fs: { allow: [resolve(import.meta.dirname, "..")] } },
})
