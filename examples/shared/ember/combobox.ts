import type { ListData, ListGroup, ListItem } from "ember-ui-sdk/combobox"

export function stringValues(value: unknown): string[] {
  return Array.isArray(value)
    ? value.filter((item): item is string => typeof item === "string")
    : []
}

export function isListItem(
  entry: ListData<unknown>[number]
): entry is ListItem<unknown> {
  return typeof entry === "object" && "value" in entry
}

export function isListGroup(
  entry: ListData<unknown>[number]
): entry is ListGroup<unknown> {
  return typeof entry === "object" && "type" in entry && entry.type === "group"
}

export function listItems(entries: ListData<unknown>): ListItem<unknown>[] {
  return entries.filter(isListItem)
}
