import { HoverCard } from "ember-ui-sdk/hover-card"

<template>
  <div class="fixture">
    <button>Before</button>
    <HoverCard @delay={{100}} @closeDelay={{100}} as |h|>
      <h.Trigger @render={{true}} as |trigger|>
        <a
          href="#repo"
          class={{if trigger.state.open "is-open" "is-closed"}}
          {{trigger.part}}
        >
          ui-sdk
          <span aria-hidden="true">{{if trigger.state.open "▲" "▼"}}</span>
        </a>
      </h.Trigger>
      <h.Content @render={{true}} as |content|>
        <section class="hover-card" aria-label="Repository" {{content.part}}>A
          headless UI kit.</section>
      </h.Content>
    </HoverCard>
    <button>After</button>
  </div>
</template>
