# ui-sdk-ember

An Ember adapter for [ui-sdk](https://github.com/vercel-labs/ui). The published package is `packages/ember-ui-sdk` (`ember-ui-sdk`). `playground/` is a private app with the fixtures that upstream's specs run against.

## Layout

- `packages/ember-ui-sdk`: the package. Each component is a module in `src/`, exported per entry point (`ember-ui-sdk/tabs`); the Glimmer templates are `.gts`.
- `playground`: the fixture app, Embroider with Vite.
- `vendor/ui`: upstream, a git submodule pinned to the `@ui-sdk/core` tag we depend on. Never edit it.
- `playwright.upstream.config.ts`: runs upstream's specs against the playground, and lists known gaps with their reasons.

## Commands

- `pnpm install`: after `git submodule update --init`.
- `pnpm typecheck`: every package and the playground.
- `pnpm format` / `pnpm format:write`: Prettier check and fix.
- `pnpm test:upstream`: upstream specs (Chromium). Run it for whatever you touch, and pass `-- --shard=N/4` to split it.

Don't install new packages without asking. `@changesets/cli` and `prettier` are already at the root.

## Conventions

- Commits are conventional, with a lowercase subject, like `fix(ember): focus the tab on arrow keys`.
- A user-visible change to `packages/ember-ui-sdk` needs a changeset: `pnpm changeset`. Docs, tests and tooling don't.
- Behavior comes from `@ui-sdk/core`. Keep the Ember layer thin, and keep component names and parts the same as the other frameworks.
