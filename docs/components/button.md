---
title: Button
description: Run an action, show that it's working, and keep it reachable when disabled.
---

Button renders a native `button` and adds what it doesn't do on its own: it stays pending while an async action runs, so a form can't submit twice, announces slow actions to screen readers, can stay focusable while disabled, and keeps the same behavior when it renders a link. For a plain click handler, a native `button` is enough.

[button/basic](../../examples/components/button/ember/basic.gts)

Click Button, or focus it and press Enter or Space. The console logs each press.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Usage

Use `@onClick` to run an action. Button renders a native `<button>` with `type="button"` by default.

```gts
import { Button } from "ember-ui-sdk/button"

<template>
  <Button @onClick={{this.save}}>Save</Button>
</template>
```

## Pending

Return a Promise from `@onClick` to keep the button pending until it settles. The button keeps focus and ignores further presses while it waits.

```gts
<Button @onClick={{this.save}} @pendingAnnouncement="Saving">
  Save
</Button>
```

After one second, it announces "Loading" to screen readers. Set `@pendingAnnouncement` to change that message, as above, or use an empty string to silence it.

[button/pending](../../examples/components/button/ember/pending.gts)

Press Save, then press it again while it saves. Nothing happens until the first action finishes.

## Pending Content

To change what the button shows while it waits, mark content with `data-show="idle"` or `data-show="pending"` and hide it in the other state with one CSS rule each:

```css
[data-slot="button"]:not([data-pending]) [data-show="pending"],
[data-slot="button"][data-pending] [data-show="idle"] {
  display: none;
}
```

```gts
<Button @onClick={{this.save}}>
  <span data-show="idle">{{icon ArrowDownToLine}}</span>
  <span data-show="pending">{{icon LoaderCircle}}</span>
  Save
</Button>
```

[button/pending-content](../../examples/components/button/ember/pending-content.gts)

Press Save. Its arrow turns into a spinner while it saves.

Keep the label and change only the visual, as above. If the text has to change too, swap it the same way, without an `aria-label`. [Pending Buttons](#pending-buttons) explains why:

```gts
<Button @onClick={{this.save}}>
  <span data-show="idle">Save</span>
  <span data-show="pending">Saving…</span>
</Button>
```

## Handling Errors

If the handler throws or its Promise rejects, `state.error` holds the error. Pass `@render={{true}}` to show it beside the button, or to change its label. The next press clears the error and runs the handler again.

[button/render](../../examples/components/button/ember/render.gts)

Choose Save Changes. Saving always fails here: the console shows the error and the label changes to Try Again.

## Disabled

Set `@disabled={{true}}` to prevent presses and remove the button from the tab order. A disabled fieldset around the button disables it too.

```gts
<Button @disabled={{true}}>Disabled</Button>
```

[button/disabled](../../examples/components/button/ember/disabled.gts)

Try clicking the button. It does nothing, and Tab skips it.

## Focusable When Disabled

Add `@focusableWhenDisabled={{true}}` when people should still be able to focus a disabled button. It uses `aria-disabled` instead of the native `disabled` attribute. Presses still do nothing.

Use `aria-describedby` to explain why the action is unavailable:

```gts
<Button @disabled={{true}} @focusableWhenDisabled={{true}} aria-describedby="publish-hint">
  Publish
</Button>
<p id="publish-hint">Add a title to publish.</p>
```

[button/focusable-when-disabled](../../examples/components/button/ember/focusable-when-disabled.gts)

Focus Title, then press Tab to reach Publish while it is disabled. Enter a title to enable it, then choose Publish. The console logs what was published.

## Links

Pass `@render={{true}}` to render an `<a>`, and spread the part onto it with `{{b.part}}`. It keeps its `href` and link semantics, including opening in a new tab. A disabled link cannot navigate and leaves the tab order.

```gts
<Button @render={{true}} as |b|>
  <a {{b.part}} href="/docs/ember">Get started</a>
</Button>
```

[button/link](../../examples/components/button/ember/link.gts)

Choose Get Started to jump to Installation on this page. Changelog is disabled and does not navigate.

## Forms

Set `@type="submit"` to submit a form or `@type="reset"` to restore its default values. The default, `"button"`, does neither.

```gts
<Button @type="submit">Subscribe</Button>
<Button @type="reset">Reset</Button>
```

[button/form](../../examples/components/button/ember/form.gts)

Edit the email and choose Subscribe, or press Enter in the field. The console logs each submission, and Reset restores the original email.

Button tracks the Promise returned by its own `@onClick`, not one from the form's submit handler. For an async submit handler, keep your own pending flag and set `@disabled` on the button while it runs, with [`@focusableWhenDisabled`](#focusable-when-disabled) so the button keeps focus while it waits.

## Styling

Use `data-pending` to show a spinner or waiting cursor, and `data-disabled` to style an unavailable action. The button's `data-slot` is `button`, and its attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/button#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [button reference](https://ui-sdk.dev/docs/react/components/button) in the upstream docs.

Button accepts native button attributes and the options below. With `@render={{true}}`, it yields `{ part, state }`, so a link or another element can read the button's state.

### Events

| Argument   | Receives                                                                                                                   |
| ---------- | -------------------------------------------------------------------------------------------------------------------------- |
| `@onClick` | The native click event and `{ source }`, how the button was pressed. A returned Promise keeps it pending until it settles. |

## Accessibility

Give the button a clear text label. If it contains only an icon, add an `aria-label`. Native buttons respond to Enter and Space; links respond to Enter.

### Pending Buttons

While its action runs, the button tells assistive technology it's busy, so you don't need to add anything:

- It sets `aria-busy="true"` and `aria-disabled="true"`, and ignores presses until the action settles. It keeps focus the whole time.
- After a second, it announces `@pendingAnnouncement` ("Loading" by default) through a polite live region. Quick actions stay silent. This is a status message: people hear it without focus moving.

To show progress, keep the label and change only the visual, like a spinner. Changing the text renames the button while it has focus: screen readers don't reliably announce a new name on the focused element, so the change mostly helps sighted users, and the button's width shifts as the text changes length. The announcement already tells everyone it's working.

If the text has to change anyway, swap it with `data-show` and leave out `aria-label`, so the button's name always contains the text on screen. See [Pending Content](#pending-content) for the markup.

References:

- [WCAG 2.5.3 Label in Name](https://www.w3.org/WAI/WCAG22/Understanding/label-in-name.html)
- [WCAG 4.1.3 Status Messages](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html)
- [WAI-ARIA `aria-busy`](https://www.w3.org/TR/wai-aria-1.2/#aria-busy) and [`aria-disabled`](https://www.w3.org/TR/wai-aria-1.2/#aria-disabled)
