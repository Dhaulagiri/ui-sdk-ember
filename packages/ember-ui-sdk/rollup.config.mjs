import { Addon } from "@embroider/addon-dev/rollup"
import { babel } from "@rollup/plugin-babel"
import { nodeResolve } from "@rollup/plugin-node-resolve"
import { readFileSync } from "node:fs"

const addon = new Addon({ srcDir: "src", destDir: "dist" })
const { exports: entries } = JSON.parse(
  readFileSync(new URL("./package.json", import.meta.url), "utf8")
)

export default {
  output: addon.output(),
  plugins: [
    addon.publicEntrypoints(
      Object.keys(entries)
        .filter((entry) => entry !== "./package.json")
        .map((entry) => `${entry.slice(2)}.js`)
    ),
    addon.dependencies(),
    nodeResolve({ extensions: [".js", ".ts", ".gts"] }),
    babel({
      babelHelpers: "bundled",
      extensions: [".js", ".ts", ".gts"],
    }),
    addon.gjs(),
    addon.declarations("declarations", "ember-tsc -p tsconfig.build.json"),
    addon.clean(),
  ],
}
