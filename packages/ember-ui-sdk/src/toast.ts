import {
  createToaster as createCoreToaster,
  toast as coreToast,
  type Toaster,
} from "@ui-sdk/core/toast"
import type { ToastContent } from "./toast/types"

/**
 * Shows a toast from anywhere: `toast("Saved")`, `toast.success(...)`,
 * `toast.promise(save(), { loading, success, error })`. Content is text or a component.
 * @experimental
 */
const toast = coreToast as Toaster<ToastContent>

/**
 * Creates a queue of toasts and the function that adds to it, for a second
 * region with its own toasts. Pass it to that region as `@toaster`.
 * @experimental
 */
const createToaster = createCoreToaster as <Content = ToastContent>(
  options?: Parameters<typeof createCoreToaster>[0]
) => Toaster<Content>

export type {
  Toast as ToastData,
  ToastAction as ToastActionData,
  ToastActionDetails,
  ToastActionProps,
  ToastButtonState,
  ToastCancel,
  ToastCloseProps,
  ToastDismissDetails,
  ToastDismissReason,
  Toaster,
  ToastItem,
  ToastOptions,
  ToastPauseReason,
  ToastRegionOptions,
  ToastRegionPrimitive,
  ToastRegionState,
  ToastState,
  ToastType,
} from "@ui-sdk/core/toast"

export { createToaster, toast }
export { default as ToastRegion } from "./toast/toast-region.gts"
export { default as Toast } from "./toast/toast.gts"
export { default as ToastTitle } from "./toast/toast-title.gts"
export { default as ToastDescription } from "./toast/toast-description.gts"
export { default as ToastAction } from "./toast/toast-action.gts"
export { default as ToastClose } from "./toast/toast-close.gts"
export type { ToastContent } from "./toast/types"
