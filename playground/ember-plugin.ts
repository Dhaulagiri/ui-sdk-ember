import { transformAsync } from "@babel/core"
import { Preprocessor } from "content-tag"
import { init, parse } from "es-module-lexer"
import { readFileSync } from "node:fs"
import { createRequire } from "node:module"
import type { Plugin } from "vite"

// Compiles template tags and ember-ui-sdk's decorators, and resolves the
// modules ember-source ships under the names apps import. Only Ember's files
// go through it.
const emberFiles = /\.gts$|\/packages\/ember-ui-sdk\/src\/.*\.ts$/

const require = createRequire(import.meta.url)
const emberRoot = require.resolve("ember-source/package.json").slice(0, -13)
const renamed: Record<string, string> = JSON.parse(
  readFileSync(`${emberRoot}/package.json`, "utf8")
)["ember-addon"]["renamed-modules"]

function emberModule(id: string) {
  const file = renamed[`${id}/index.js`] ?? renamed[`${id}.js`]
  return file && `${emberRoot}/dist/dev/packages/${file.slice(13)}`
}

function ember() {
  const preprocessor = new Preprocessor()
  const compiler = import(
    `${emberRoot}/dist/dev/packages/ember-template-compiler/index.js`
  )
  const plugin: Plugin = {
    name: "ember",
    enforce: "pre",
    // Vite versions imports from node_modules but not the app's, which would
    // load two copies of a module like @ember/runloop, each with its own run
    // loop. Routing every import through one re-export keeps one.
    resolveId(id) {
      return emberModule(id) && `\0ember:${id}`
    },
    async load(id) {
      if (!id.startsWith("\0ember:")) {
        return
      }
      const file = emberModule(id.slice(7))!
      await init
      const [, exports] = parse(readFileSync(file, "utf8"))
      const hasDefault = exports.some(({ n }) => n === "default")
      return `export * from ${JSON.stringify(file)}\n${
        hasDefault ? `export { default } from ${JSON.stringify(file)}\n` : ""
      }`
    },
    async transform(code, id) {
      const file = id.split("?")[0]
      if (!emberFiles.test(file)) {
        return
      }
      const source = file.endsWith(".gts")
        ? preprocessor.process(code, { filename: file }).code
        : code
      const result = await transformAsync(source, {
        filename: file.replace(/\.gts$/, ".ts"),
        babelrc: false,
        configFile: false,
        sourceMaps: true,
        plugins: [
          [
            require.resolve("@babel/plugin-transform-typescript"),
            { allExtensions: true, onlyRemoveTypeImports: true },
          ],
          [
            require.resolve("babel-plugin-ember-template-compilation"),
            { compiler: await compiler, targetFormat: "wire" },
          ],
          [
            require.resolve("decorator-transforms"),
            { runtime: { import: "decorator-transforms/runtime" } },
          ],
        ],
      })
      return result?.code ? { code: result.code, map: result.map } : undefined
    },
  }
  return plugin
}

export { ember }
