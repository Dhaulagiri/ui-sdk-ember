---
"ember-ui-sdk": patch
---

Document handing a root's instance to a part component of your own: a root yields the part with `(component MyTab handle=this.handle)` and the part calls `usePart(this, () => this.args.handle, "tab")`, wherever it renders. A part `usePart` creates without an instance now throws a clear error, "A tab part needs @handle, or the root's yielded part.", instead of a `TypeError`.
