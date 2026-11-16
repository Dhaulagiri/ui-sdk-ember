import { HoverCard } from "ember-ui-sdk/hover-card"

<template>
  <HoverCard as |h|>
    <h.Trigger href="https://example.com/people/hollis">@hollis</h.Trigger>
    <h.Content>
      <div data-slot="row">
        <span data-slot="initials" aria-hidden="true">HG</span>
        <div data-slot="stack">
          <p>Hollis Grant</p>
          <p>Design engineer on the payments team. Writes about forms and
            motion.</p>
          <p data-slot="hint">Joined March 2021</p>
        </div>
      </div>
    </h.Content>
  </HoverCard>
</template>
