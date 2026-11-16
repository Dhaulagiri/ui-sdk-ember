import { Archive, Clock, File, Pencil, Reply, Star } from "lucide"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { icon } from "../../../shared/ember/icon"

const mailSearches = [
  { value: "Starred", icon: Star },
  { value: "Drafts", icon: Pencil },
  { value: "Replies", icon: Reply, mirror: true },
  { value: "Attachments", icon: File },
  { value: "Archived", icon: Archive },
  { value: "Scheduled", icon: Clock },
]

<template>
  <Autocomplete as |c|>
    <c.Input
      type="search"
      aria-label="Search mail"
      placeholder="Search mail…"
    />
    <c.Content>
      <c.Empty>No searches found.</c.Empty>
      <c.List>
        {{#each mailSearches key="value" as |search|}}
          <c.Item @value={{search.value}} as |item|>
            <item.Icon @mirror={{search.mirror}}>{{icon
                search.icon
              }}</item.Icon>
            {{search.value}}
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
