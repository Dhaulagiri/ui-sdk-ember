import { Dialog } from "ember-ui-sdk/dialog"

<template>
  <div class="fixture">
    <button>Before</button>
    <Dialog as |d|>
      <d.Trigger @render={{true}} as |trigger|>
        <button
          class={{if trigger.state.open "is-open" "is-closed"}}
          {{trigger.part}}
        >
          Shipping
          <span aria-hidden="true">{{if trigger.state.open "▲" "▼"}}</span>
        </button>
      </d.Trigger>
      <d.Backdrop @render={{true}} as |backdrop|>
        <section class="dialog-backdrop" {{backdrop.part}}></section>
      </d.Backdrop>
      <d.Content class="dialog" as |content|>
        <span
          class={{if content.state.open "is-open" "is-closed"}}
          hidden
        ></span>
        <d.Title @render={{true}} as |title|>
          <h3 {{title.part}}>Shipping</h3>
        </d.Title>
        <d.Description @render={{true}} as |description|>
          <div {{description.part}}>Arrives in two days.</div>
        </d.Description>
        <d.Close @render={{true}} as |close|>
          <a href="#done" {{close.part}}>Done</a>
        </d.Close>
      </d.Content>
    </Dialog>
    <button>After</button>
  </div>
</template>
