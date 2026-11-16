import { applyFixtureOptions, loadScreenReader } from "tests/fixtures/page.ts"

// The page ui-sdk's specs open: /?fixture=menu&framework=ember loads
// src/fixtures/menu/ember.ts, and ember-data loads ember-data.ts.
const fixtures = import.meta.glob("./fixtures/*/ember*.ts")

// Three specs load core's own modules through the page, so they must be the
// copies the fixtures use: the installed package's, not a source checkout.
const coreModules = import.meta.glob(
  "../node_modules/@ui-sdk/core/dist/foundation/*/*.js"
)
const loadCoreModule = (name: string) =>
  Object.entries(coreModules).find(([file]) =>
    file.endsWith(`/${name}.js`)
  )![1]()
Object.assign(window, {
  loadCoreModule,
  loadTesting: () => import("@ui-sdk/core/testing"),
})

const params = applyFixtureOptions()
const fixture = params.get("fixture")
const framework = params.get("framework") ?? "ember"
const path =
  fixture &&
  framework.startsWith("ember") &&
  Object.keys(fixtures).find((key) =>
    key.startsWith(`./fixtures/${fixture}/${framework}.`)
  )
const root = document.getElementById("root")!
// Specs read this to skip right after load, so it is set before any await.
if (fixture && !path) {
  document.body.dataset.missingFixture = ""
}
// A popup loads its sheet code in idle time, and specs press as soon as the
// page is up, so a page that presents popups as sheets loads it first.
if (params.has("presentation") && !params.has("lazy")) {
  await loadCoreModule("sheet-presentation")
}
if (params.has("agent")) {
  Object.assign(window, {
    __agent: (await import("@ui-sdk/core/agent")).createAgent(),
  })
}

if (!fixture) {
  root.innerHTML = `<h1>ember-ui-sdk fixtures</h1><ul>${Object.keys(fixtures)
    .map((key) => key.match(/^\.\/fixtures\/([^/]+)\/([^.]+)\.ts$/)!)
    .map(
      ([, name, entry]) =>
        `<li><a href="/?fixture=${name}&framework=${entry}">${name} (${entry})</a></li>`
    )
    .join("")}</ul>`
} else if (!path) {
  document.body.textContent = `No fixture for ${fixture} in ${framework}.`
} else {
  const module = (await fixtures[path]()) as {
    mount: (root: HTMLElement) => void | Promise<void>
  }
  // Ember fixtures render off the page and join it before parts bind, a
  // microtask later. The stage itself joins, since Ember's top-level blocks
  // keep it as their parent.
  const stage = document.createElement("div")
  const mounted = module.mount(stage)
  stage.style.display = "contents"
  root.append(stage)
  await mounted
  document.body.dataset.mounted = ""
  await loadScreenReader()
}
