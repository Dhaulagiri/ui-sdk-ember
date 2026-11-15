import { registerDestructor } from "@ember/destroyable"
import { tracked } from "@glimmer/tracking"
import { onSync, type PrimitiveHandle } from "./use-primitive"

// The root each controller is attached to, read by parts outside it, like a
// trigger elsewhere on the page. `version` changes with every registration,
// so a part that read a controller with no root yet renders again.
const controlled = new Map<object, PrimitiveHandle>()

class Registry {
  @tracked version = 0
}

const registry = new Registry()

/**
 * Registers a root with its controller for the life of `owner`, so parts
 * outside it find it, again whenever the controller changes. It registers
 * after the render that made it, which a part rendered before it may have read.
 */
function registerController(
  owner: object,
  controller: () => object | undefined,
  handle: PrimitiveHandle
) {
  let current: object | undefined
  let destroyed = false
  const release = () => {
    if (current && controlled.get(current) === handle) {
      controlled.delete(current)
    }
  }
  const register = () =>
    queueMicrotask(() => {
      const next = destroyed ? undefined : controller()
      if (next === current) {
        return
      }
      release()
      current = next
      if (current) {
        controlled.set(current, handle)
      }
      registry.version++
    })
  register()
  const stop = onSync(handle, register)
  registerDestructor(owner, () => {
    destroyed = true
    stop()
    release()
    register()
  })
}

/** The root a part connects to: its controller's, else `nearest`. Reading it tracks it. */
function controllerTarget<P extends PrimitiveHandle>(
  controller: object | undefined,
  nearest: P | undefined
) {
  if (!controller) {
    return nearest
  }
  registry.version
  return (controlled.get(controller) as P | undefined) ?? nearest
}

export { controllerTarget, registerController }
