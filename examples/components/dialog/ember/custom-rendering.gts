import { Dialog } from "ember-ui-sdk/dialog"

<template>
  <Dialog as |d|>
    <d.Trigger @shortcut="mod+i" @render={{true}} as |t|>
      <button {{t.part}} type="button">
        {{if t.state.open "Viewing" "View Details"}}
        <d.Shortcut as |s|>{{s.state.text}}</d.Shortcut>
      </button>
    </d.Trigger>
    <d.Backdrop />
    <d.Content as |content|>
      <div data-slot="stack">
        <d.Title @render={{true}} as |t|>
          <h3 {{t.part}}>Details</h3>
        </d.Title>
        <d.Description>
          {{if
            content.state.nested
            "Opened from another dialog."
            "Quarterly report, updated today."
          }}
        </d.Description>
      </div>
      <div data-slot="row">
        <d.Close>Close</d.Close>
        <d.Close data-variant="solid" @render={{true}} as |c|>
          <a {{c.part}} href="https://example.com/details">Open the Full Page</a>
        </d.Close>
      </div>
    </d.Content>
  </Dialog>
</template>
