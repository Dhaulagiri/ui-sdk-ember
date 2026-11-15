import { resolve } from "node:path"
import { defineConfig, type Plugin } from "vite"
import { ember } from "./ember-plugin.ts"

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

// The fixtures share their data and helpers with ui-sdk's specs, which live in
// the vendor/ui submodule, so "tests/..." resolves there.
export default defineConfig({
  plugins: [vendorCore, ember()],
  resolve: {
    alias: { tests: resolve(import.meta.dirname, "../vendor/ui/tests") },
  },
  optimizeDeps: { exclude: ["@glimmer/component"] },
  server: { fs: { allow: [resolve(import.meta.dirname, "..")] } },
})
