---
title: Custom Parts
description: Write a part with its own Ember logic and connect it to a primitive.
---

The generated components are enough until one needs its own logic. You can write a root that creates a primitive's instance and a part that binds one slot of it, using the `rating.ts` definition from [Compose Behaviors](https://ui-sdk.dev/docs/core/compose-behaviors#complete-primitive).

## Write a Root

`usePrimitive` creates the instance from the component's arguments for the life of the component. `usePart` binds the `root` slot, and `syncOptions` hands the arguments to the instance whenever they change. Put it first in the template:

```gts title="rating-root.gts"
import Component from "@glimmer/component"
import { syncOptions, usePart, usePrimitive } from "ember-ui-sdk/primitive"
import { rating } from "./rating"

export default class RatingRoot extends Component {
  handle = usePrimitive(this, rating)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    <div ...attributes {{this.root.modifier}}>{{yield}}</div>
  </template>
}
```

Controlled options follow data down and actions up: `@value` with `@onValueChange`. Pass a third argument to `usePrimitive` for options the arguments don't hold.

A child part takes the root's `handle` as an argument and calls `usePart` with its own slot. A part's `present`, `attrs`, `state` and `modifier` track what they read.

## Type What a Root Yields

The roots type what they yield, so `c.part`, `c.state` and `c.Panel` check in strict templates, `noPropertyAccessFromIndexSignature` included. Type your own root's block the same way: `RootYield` gives the `part` modifier, the slot's `state` and the `handle`, and `WithBoundArgs` each part with the arguments the root binds.

```gts title="rating-root.gts"
import Component from "@glimmer/component"
import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import {
  syncOptions,
  usePart,
  usePrimitive,
  type RootYield,
} from "ember-ui-sdk/primitive"
import { rating } from "./rating"
import RatingStar from "./rating-star"

export default class RatingRoot extends Component<{
  Blocks: {
    default: [
      RootYield<typeof rating> & {
        Star: WithBoundArgs<typeof RatingStar, "handle">
      },
    ]
  }
}> {
  handle = usePrimitive(this, rating)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    <div ...attributes {{this.root.modifier}}>{{yield
        (hash
          part=this.root.modifier
          state=this.root.state
          handle=this.handle
          Star=(component RatingStar handle=this.handle)
        )
      }}</div>
  </template>
}
```

A root bound to another slot, like a group's, names it: `RootYield<typeof radioGroup, "group">`. The `part` modifier binds any element, so it also fits a `ModifierLike<{ Element: HTMLElement }>`.

## Bind a Part From Another Component

Ember has no context, so a part finds its root through an argument. A root that yields a part component of your own binds its instance to it with `(component)`, and the part hands that instance to `usePart`. The part binds to that root wherever it renders: in the root's template, or in the block of the app that uses the root.

```gts title="app-tabs.gts"
import Component from "@glimmer/component"
import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import { tabs, type TabsPrimitive } from "@ui-sdk/core/tabs"
import {
  syncOptions,
  usePart,
  usePrimitive,
  type PrimitiveHandle,
} from "ember-ui-sdk/primitive"

class AppTab extends Component<{
  Element: HTMLButtonElement
  Args: {
    /** The tabs' instance, which AppTabs binds. */
    handle: PrimitiveHandle<TabsPrimitive>
    value: string
  }
  Blocks: { default: [] }
}> {
  part = usePart(
    this,
    () => this.args.handle,
    "tab",
    () => ({ value: this.args.value })
  )

  <template>
    <button
      type="button"
      ...attributes
      {{this.part.modifier}}
    >{{yield}}</button>
  </template>
}

export default class AppTabs extends Component<{
  Blocks: { default: [{ Tab: WithBoundArgs<typeof AppTab, "handle"> }] }
}> {
  handle = usePrimitive(this, tabs)
  list = usePart(this, () => this.handle, "list")

  <template>
    {{syncOptions this.handle}}
    <div {{this.list.modifier}}>
      {{yield (hash Tab=(component AppTab handle=this.handle))}}
    </div>
  </template>
}
```

```gts
<AppTabs as |t|>
  <t.Tab @value="a">Alpha</t.Tab>
  <t.Tab @value="b">Beta</t.Tab>
</AppTabs>
```

`WithBoundArgs` leaves `@handle` out of the type the app sees, so the instance stays between your root and your part. Keep it in an argument rather than a module-level map: the argument follows Ember's rendering, so each root's parts bind to that root, and nothing outlives it.

A part created without an instance throws, as it does in the other frameworks, so a part you render alone needs its root's `handle` passed by hand.
