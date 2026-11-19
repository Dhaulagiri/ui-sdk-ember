---
"ember-ui-sdk": minor
---

Document and support handing a root's instance to a part component of your own. A root yields the part with `(component MyTab handle=this.handle)` and the part calls `usePart(this, () => this.args.handle, "tab")`, wherever it renders. `usePart` now also takes a handle that may be missing: a part created without a root is detached, present with empty state and a modifier that binds nothing, so one component can render with or without its root instead of throwing.
