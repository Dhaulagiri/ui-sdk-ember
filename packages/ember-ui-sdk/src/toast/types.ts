import type { Toast as ToastData } from "@ui-sdk/core/toast"

/**
 * What a toast shows: text or a component.
 * @experimental
 */
type ToastContent = string | object

type ToastParts = Record<string, unknown>

export type { ToastContent, ToastData, ToastParts }
