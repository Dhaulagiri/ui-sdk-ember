# Custom Parts

Write a part with its own Ember logic and connect it to a primitive.

The generated components are enough until one needs its own logic. You can write a root that creates a primitive's instance and a part that binds one slot of it, using the `rating.ts` definition from [Compose Behaviors](../core.md#complete-primitive).

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
