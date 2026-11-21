// Type tests for `onInsert`, checked by `pnpm typecheck`.
import { onInsert } from "ember-ui-sdk/primitive"

const measure = (_el: HTMLElement) => {}
const watch = (_el: HTMLElement) => () => {}

<template>
  <div {{onInsert measure}}></div>
  <div {{onInsert watch}}></div>
  {{! @glint-expect-error it takes a callback }}
  <div {{onInsert "measure"}}></div>
</template>
