import assert from "node:assert/strict"
import { execFileSync } from "node:child_process"
import { mkdtemp, readFile, readdir, rm } from "node:fs/promises"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { after, test } from "node:test"

const temporary = await mkdtemp(join(tmpdir(), "ember-ui-sdk-packed-"))
after(() => rm(temporary, { recursive: true, force: true }))
execFileSync("tar", ["-xzf", "artifacts/ember-ui-sdk.tgz", "-C", temporary])
const packed = join(temporary, "package")
const manifest = JSON.parse(
  await readFile(join(packed, "package.json"), "utf8")
)

test("the tarball is a v2 addon with a loadable classic shim", async () => {
  assert.deepEqual(manifest["ember-addon"], {
    version: 2,
    type: "addon",
    main: "addon-main.cjs",
  })
  assert.match(
    await readFile(join(packed, "addon-main.cjs"), "utf8"),
    /addonV1Shim/
  )
  assert.ok(manifest.dependencies["@embroider/addon-shim"])
})

test("every public entry exports JavaScript and declarations", async () => {
  const source = JSON.parse(
    await readFile("packages/ember-ui-sdk/package.json", "utf8")
  )
  assert.deepEqual(Object.keys(manifest.exports), Object.keys(source.exports))
  for (const [name, targets] of Object.entries(manifest.exports)) {
    if (name === "./package.json") continue
    assert.match(targets.default, /^\.\/dist\/.*\.js$/)
    assert.match(targets.types, /^\.\/declarations\/.*\.d\.ts$/)
    await readFile(join(packed, targets.default))
    await readFile(join(packed, targets.types))
  }
})

test("the tarball has no raw source or declaration references to gts", async () => {
  const files = await readdir(packed, { recursive: true })
  assert.ok(!files.includes("src"))
  for (const file of files) {
    assert.ok(!file.endsWith(".gts"), `raw template shipped: ${file}`)
    if (!file.endsWith(".d.ts")) continue
    assert.doesNotMatch(
      await readFile(join(packed, file), "utf8"),
      /(?:from\s*|import\()["'][^"']*(?:\.gts|\.gjs|node_modules)[^"']*["']/,
      `non-portable declaration: ${file}`
    )
  }
})
