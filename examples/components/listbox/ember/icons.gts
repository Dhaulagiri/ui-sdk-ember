import { Listbox } from "ember-ui-sdk/listbox"
import { Archive, ArrowRight, Mail, Pencil, Star } from "lucide"
import { icon } from "../../../shared/ember/icon"

const views = [
  { value: "inbox", label: "Inbox", icon: Mail, mirror: false },
  { value: "starred", label: "Starred", icon: Star, mirror: false },
  { value: "drafts", label: "Drafts", icon: Pencil, mirror: false },
  { value: "archive", label: "Archive", icon: Archive, mirror: false },
  { value: "next", label: "Next page", icon: ArrowRight, mirror: true },
]

<template>
  <Listbox @defaultValue="inbox" aria-label="Mailbox" as |l|>
    {{#each views key="value" as |view|}}
      <l.Item @value={{view.value}} as |i|>
        <i.Icon @mirror={{view.mirror}}>{{icon view.icon}}</i.Icon>
        {{view.label}}
      </l.Item>
    {{/each}}
  </Listbox>
</template>
