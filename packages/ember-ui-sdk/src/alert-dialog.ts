export { default as AlertDialog } from "./alert-dialog/alert-dialog.gts"
// The parts are Dialog's: the alert dialog's slots and state are the dialog's.
export { default as AlertDialogTrigger } from "./dialog/dialog-trigger.gts"
export { default as AlertDialogBackdrop } from "./dialog/dialog-backdrop.gts"
export { default as AlertDialogContent } from "./dialog/dialog-content.gts"
export { default as AlertDialogTitle } from "./dialog/dialog-title.gts"
export { default as AlertDialogDescription } from "./dialog/dialog-description.gts"
export { default as AlertDialogClose } from "./dialog/dialog-close.gts"
export { default as AlertDialogShortcut } from "./dialog/dialog-shortcut.gts"
export {
  confirm,
  createAlertDialogController,
  createConfirm,
} from "@ui-sdk/core/alert-dialog"
export type {
  AlertDialogBackdropState,
  AlertDialogCloseActionDetails,
  AlertDialogCloseProps,
  AlertDialogCloseState,
  AlertDialogContentProps,
  AlertDialogContentState,
  AlertDialogController,
  AlertDialogOpenChangeReason,
  AlertDialogOptions,
  AlertDialogPayloadChangeReason,
  AlertDialogPrimitive,
  AlertDialogShortcutProps,
  AlertDialogShortcutState,
  AlertDialogTriggerProps,
  AlertDialogTriggerState,
  ConfirmEntry,
  ConfirmOptions,
} from "@ui-sdk/core/alert-dialog"
