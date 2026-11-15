# Changesets

A changeset is a Markdown file in this folder that says which packages a change releases and how: patch, minor or major. Add one with `pnpm changeset` in a pull request that changes what users get. Docs, tests and tooling need none.

Merging to main opens or updates a "Version packages" pull request. Merging that publishes `ember-ui-sdk` to npm.
