# ui-sdk-ember

ui-sdk-ember brings [ui-sdk](https://github.com/vercel-labs/ui) to Ember. ui-sdk gives you the behaviors under a component: keyboard navigation, focus, selection, dismissal, popups and the ARIA they need. This repo ships them as Glimmer components in `ember-ui-sdk`. You write the markup and styles.

Docs and live examples: https://dhaulagiri.github.io/ui-sdk-ember/

Status: experimental. Expect breaking changes before 1.0. This project is unofficial and not affiliated with Vercel.

## Install

```bash
pnpm add ember-ui-sdk
```

Each component has its own entry point, like `ember-ui-sdk/tabs`, so an app only bundles what it imports.

## Requirements

- Ember 7 (`ember-source` 7), with `@glimmer/component` and `@glimmer/tracking` installed.
- A standard Ember addon build, such as Embroider with Vite. The package ships JavaScript and declarations, not `.gts` or TypeScript source. Its portable templates use Ember's standard template-compilation API; no package-specific source loaders are needed.
- For template typechecking, use the `@glint/template` version required by your `@glint/ember-tsc` version.
- Node 24.

## Usage

```gts
import { Tabs } from "ember-ui-sdk/tabs"

<template>
  <Tabs @defaultValue="a" as |t|>
    <t.List aria-label="Settings">
      <t.Tab @value="a">A</t.Tab>
      <t.Tab @value="b">B</t.Tab>
    </t.List>
    <t.Panel @value="a">Panel A</t.Panel>
    <t.Panel @value="b">Panel B</t.Panel>
  </Tabs>
</template>
```

The root component yields its parts, so the names match the React, Vue, Svelte, Solid and web packages. See `packages/ember-ui-sdk/README.md` for the argument mapping and the primitives for your own components.

## Testing

ui-sdk's own specs run unchanged. `vendor/ui` is a git submodule of vercel-labs/ui, pinned to the `@ui-sdk/core` release this repo depends on. Its Playwright specs run against the Ember fixtures in `playground/`, and `playwright.upstream.config.ts` maps them onto the Ember app. Failures that aren't bugs are listed under `knownGaps` in that config, each with its reason.

Run them with:

```bash
pnpm test:upstream
```

Pass `-- --shard=1/4` (and so on) to split the run.

## Development

```bash
git submodule update --init
pnpm install
pnpm build            # compile the addon (also runs during install)
pnpm --filter ember-ui-sdk watch # rebuild the addon while editing its sources
pnpm dev              # the playground app
pnpm --filter site dev     # the docs site, on port 5340 (SITE_PORT)
pnpm --filter site build   # build it; BASE_PATH=/ui-sdk-ember/ sets the base path
pnpm typecheck        # every package and the playground
pnpm format           # check formatting
pnpm format:write     # fix formatting
pnpm test:upstream    # upstream specs against the Ember fixtures
pnpm test:package     # packed-addon checks and the isolated Ember test app
pnpm pack:local       # artifacts/ember-ui-sdk.tgz; builds before packing
```

The playground and site import the built addon. Keep `pnpm --filter ember-ui-sdk watch` running alongside their dev server when changing SDK source.

`test-app/` follows the Ember app blueprint: Embroider/Vite, QUnit, Testem and ember-try. It installs the tarball independently with npm, outside the pnpm workspace, so workspace links cannot mask missing published files. Its Ember 7.4 scenario checks template types, renders tabs with keyboard navigation, and opens/dismisses a dialog with focus restoration.

The Ember 6.5 scenario checks **packaging and types only**: Ember CLI 6.5, ember-auto-import 2/webpack, `ember-tsc` 1.5.0 and `@glint/template` 1.7.7. It deliberately bypasses the unchanged Ember 7 peer requirement. It does not claim Ember 6.5 build or runtime support: that compiler rejects unbound `hash` in the SDK's strict templates. No compatibility aliases or consumer patches are applied.

To try a local build in another app, run `pnpm pack:local`, then install the absolute path to `artifacts/ember-ui-sdk.tgz` using that app's package manager. Nothing is published. With an unsupported Ember version, any peer override is experimental; the packaging fixes alone do not make Ember 6.5 a supported runtime.

## Updating vendor/ui

`vendor/ui` stays on the tag of the `@ui-sdk/core` release we depend on. To move to a new release:

```bash
cd vendor/ui
git fetch --tags
git checkout @ui-sdk/core@<version>
cd ../..
```

Then set the `@ui-sdk/core` version in `packages/ember-ui-sdk/package.json` and `playground/package.json` to match, run `pnpm install`, and run `pnpm test:upstream`. Commit the submodule pointer with the dependency change, and add a changeset if the update changes what users get.

## Releasing

Releases use [changesets](https://github.com/changesets/changesets). A pull request that changes what users get adds a changeset:

```bash
pnpm changeset
```

When a changeset lands on main, the release workflow opens or updates a "Version packages" pull request. Merging it publishes `ember-ui-sdk` to npm with provenance. Publishing uses npm trusted publishing, so the repo holds no npm token.

## License

Apache-2.0. See [LICENSE](LICENSE).
