// Type tests for a time input's arguments, checked by `pnpm typecheck`.
import { TimeInput } from "ember-ui-sdk/time-input"

<template>
  <TimeInput @min="09:00" @max="17:30" />
  {{! @glint-expect-error the bounds are strings, like 09:00 }}
  <TimeInput @min={{9}} />
</template>
