import { resolve } from "node:path"
import { defineConfig } from "vite"
import { ember } from "./ember-plugin.ts"

// The fixtures share their data and helpers with ui-sdk's specs, which live in
// the vendor/ui submodule, so "tests/..." resolves there.
export default defineConfig({
  plugins: [ember()],
  resolve: {
    alias: { tests: resolve(import.meta.dirname, "../vendor/ui/tests") },
  },
  optimizeDeps: { exclude: ["@glimmer/component"] },
  server: { fs: { allow: [resolve(import.meta.dirname, "..")] } },
})
