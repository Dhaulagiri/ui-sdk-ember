# Porting a component to ember-ui-sdk

Each component is a root plus one `.gts` file per part, all thin wrappers over
`usePrimitive` and `usePart`. Behavior stays in `@ui-sdk/core`. Tabs is the
worked example: `src/tabs.ts`, `src/tabs/*.gts`,
`playground/src/fixtures/tabs/{ember.ts,TabsFixture.gts}`.

## Files

For a component `foo` (core primitive `foo` from `@ui-sdk/core/foo`):

1. `packages/ember-ui-sdk/src/foo.ts`: the entry. Re-exports each part's default
   export by its React name and the same types the Svelte entry re-exports
   (copy `packages/svelte/src/foo.ts`, change `.svelte` to `.gts`).
2. `packages/ember-ui-sdk/src/foo/foo.gts`: the root.
3. `packages/ember-ui-sdk/src/foo/foo-<part>.gts`: one per part.
4. `playground/src/fixtures/<fixture>/ember.ts` plus a `.gts` fixture
   component, for each fixture the Svelte port has (`foo`, `foo-render`, ...).
5. The one shared line, which the coordinator adds: `"./foo": "./src/foo.ts"`
   in `packages/ember-ui-sdk/package.json` `exports`. Nothing else shared changes.

## Root

```gts
import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { foo } from "@ui-sdk/core/foo"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import FooTrigger from "./foo-trigger.gts"

/** One line, the same words as the Svelte component's doc. */
class Foo extends Component<{ Element: HTMLDivElement; Args: {...}; Blocks: { default: [object] } }> {
  handle = usePrimitive(this, foo)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Trigger=(component FooTrigger handle=this.handle)
      )
      as |f|
    }}
      {{#if @render}}
        {{yield f}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield f}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default Foo
```

- `usePrimitive(this, foo)` passes every argument but `@render` to the
  instance as an option (`@value`, `@defaultValue`, `@onValueChange`, and
  ones the schema leaves out, like Popover's `@modal`), so the root needs no
  option list. Controlled values are data down, actions up: pass `@value`
  and update it in `@onValueChange`.
- `{{syncOptions this.handle}}` must come first in the template: it hands
  changed arguments to the instance during render.
- A root without a `root` slot (Popover, Select) has no element: drop `root`
  and render `{{syncOptions this.handle}}{{yield f}}`.
- Every part goes in the yielded hash, curried with `handle`.

## Part

```gts
import Component from "@glimmer/component"
import { foo } from "@ui-sdk/core/foo"
import { usePart, type PartSignature } from "../use-part"

/** One line, the same words as the Svelte component's doc. */
class FooTrigger extends Component<
  PartSignature<typeof foo, "trigger", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default FooTrigger
```

- The slot's props come from the arguments of the same names (`@value`,
  `@disabled`). A prop of kind `"id"` that no argument gives gets a unique id.
  Props a parent supplies (`from: "item"`, a group id) go in `usePart`'s fourth
  argument, `() => ({ item: this.args.item })`, and the parent curries them:
  `Indicator=(component SelectItemIndicator handle=@handle item=this.key)`.
- The tag is the one the Svelte part passes to `<Part tag=...>`.
- A part the Svelte port wraps in `{#if part.present}` wraps everything in
  `{{#if this.part.present}}...{{/if}}`.
- `@render={{true}}` renders no element and yields `{ part, state }`: the
  caller binds its own element with `{{x.part}}`. This is the `render` of the
  other frameworks. `...attributes` don't reach that element, so classes and
  `href` go on the caller's element.
- Default content the Svelte part renders (a shortcut's text, a select
  value's label) goes in `{{else}}` of `{{#if (has-block)}}`.
- Nested context (Svelte `setContext`) becomes another yielded hash: an item
  yields `(hash part=... state=... Text=(component ... item=key))`.
- Popups: render content inside `{{#in-element target insertBefore=null}}`
  when `portalTarget(container)` returns an element (see `src/popup.ts`).

## Generating the plain parts

`node scripts/ember-parts.mjs foo` writes `src/foo.ts` and every plain part
(one `usePart`/`useHandlePart` call and a `<Part tag>`, maybe inside
`{#if x.present}`) from the Svelte port, and lists the files to port by hand:
the root, triggers, popup content, parts with context or snippets. It never
replaces a file. Read what it wrote: a part whose Svelte file passes props
from context needs them in `usePart`'s fourth argument.

## Patterns from Popover and Select

- **Triggers outside the root** (`@controller`): the root calls
  `registerController(this, () => this.args.controller, this.handle)` in its
  constructor. The trigger resolves `controllerTarget(@controller, @handle)`
  and renders `<XTriggerBinding @handle=...>` (the bound part) once there is
  one, else a plain button. See `popover/popover-trigger.gts`.
- **Popups**: content renders a `viewport` and a `content` part inside
  `<Portal @to={{this.target}}>`, `target` being
  `portalTarget(@container ?? @rootContainer)`; the root curries
  `rootContainer=@container`. Copy `popover/popover-content.gts`.
- **Feature slots** (`instance.use(selectSelectAll)`): take the feature in a
  class field declared before the `usePart` field, since fields run in order
  and `usePart` registers the part at once. See `select/select-select-all.gts`.
- **Text read from content** (Svelte attachments that learn text): use the
  `onInsert` modifier and set tracked state through `afterRender`. See
  `select/select-item-text.gts`.
- **Hidden form inputs**: render them in the root after the yield, as
  `select/select.gts` does. `this.part.attrs` tracks a part's attributes.

## Fixture

`playground/src/fixtures/foo/ember.ts`:

```ts
import { renderComponent } from "@ember/renderer"
import FooFixture from "./FooFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(FooFixture, { into: root })
}

export { mount }
```

`FooFixture.gts` mirrors `FooFixture.svelte` element for element: same
classes, labels, ids, `tests/fixtures/*` imports and URL options. Svelte
`$state` becomes `@tracked`, `onclick` becomes `{{on "click" ...}}`,
`{#each xs as x (x.id)}` becomes `{{#each xs key="id" as |x|}}`. Pass options
as named arguments one by one (Ember has no argument spread).

## Running specs

From `tests/`, with a port of your own:

```bash
PLAYGROUND_PORT=5381 bash ../scripts/test-slot.sh npx playwright test specs/foo --project ember
PLAYGROUND_PORT=5381 bash ../scripts/test-slot.sh npx playwright test specs/foo --project svelte
```

Check the exit code. Compare with `--project svelte`: a test that fails there
too isn't the port's problem. Specs for frameworks without a fixture skip, so
a spec file only runs on ember once `ember.ts` exists. Kitchen sinks and count
gates run only for react, vue and web.

## Pitfalls

- `.gts` imports of other `.gts` files need the extension: `./foo-item.gts`.
- A binding named like an HTML tag (`button`, `label`, `input`, `form`) turns
  `<button>` in that file's templates into the binding. Alias such imports and
  constants (`import { button as buttonPrimitive }`).
- Two parts on one element (a field's control on a control's root) need their
  own channels: `usePart`'s default channel is per part, so don't share one.
- Controls inside a Field take `@field={{f.field}}` from the Field's yield.
- Import `hash`, `fn`, `array`, `eq` from `@ember/helper` and `on` from
  `@ember/modifier`; strict mode has no globals besides `component`, `if`,
  `each`, `let`, `yield`, `has-block` and `in-element`.
- Never set tracked state while Ember renders: changes the core reports
  during render reach templates a microtask later (`afterRender`).
- Glimmer keeps the whitespace between elements, which Svelte drops. A spec
  that matches text with `^` fails on the leading newline: strip it with
  `{{~!~}}` in the fixture (see `FixtureItem` in the Select fixture).
- `...attributes` never reaches the element in `@render` mode, and Ember has
  no argument spread: list each option as a named argument.
- A part can't be read before a nested part's context exists: anything
  Svelte keeps in `setContext` is curried into the yielded components.
- Parts register as they render but bind once Ember commits, after the DOM
  is in the page. A selection the core makes only from bound parts (Tabs
  with no default value) appears in a second render, and a screen reader
  reading attributes that depend on another part being bound (a tab's
  `aria-controls`) reads them one render late. Two Tabs specs fail on it.
- Components a fixture uses that aren't ported yet (Menu in the Popover
  fixture, Field in the Select fixture) are left out, and their specs fail
  or skip until they are.
