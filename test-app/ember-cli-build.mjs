import EmberApp from "ember-cli/lib/broccoli/ember-app.js"
import { compatBuild } from "@embroider/compat"
import mergeTrees from "broccoli-merge-trees"

export default async function (defaults) {
  if (process.env.CLASSIC_BUILD) {
    return new EmberApp(defaults, {
      trees: {
        app: mergeTrees(["app", "classic/app"], { overwrite: true }),
        tests: mergeTrees(["tests", "classic/tests"], { overwrite: true }),
      },
    }).toTree()
  }
  const { buildOnce } = await import("@embroider/vite")
  return compatBuild(new EmberApp(defaults), buildOnce)
}
