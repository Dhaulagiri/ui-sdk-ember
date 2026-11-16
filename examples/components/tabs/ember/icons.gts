import { Archive, Mail, Reply } from "lucide"
import { Tabs } from "ember-ui-sdk/tabs"
import { icon } from "../../../shared/ember/icon"

<template>
  <Tabs @defaultValue="inbox" as |t|>
    <t.List aria-label="Mail">
      <t.Tab @value="inbox">
        <t.TabIcon>{{icon Mail}}</t.TabIcon>
        Inbox
      </t.Tab>
      <t.Tab @value="replies">
        <t.TabIcon @mirror={{true}}>{{icon Reply}}</t.TabIcon>
        Replies
      </t.Tab>
      <t.Tab @value="archive">
        <t.TabIcon>{{icon Archive}}</t.TabIcon>
        Archive
      </t.Tab>
    </t.List>
    <t.Panel @value="inbox">3 new messages from Inès Moreau and Kofi Mensah.</t.Panel>
    <t.Panel @value="replies">Wren Takahashi replied to your message about the
      launch.</t.Panel>
    <t.Panel @value="archive">Messages you archived stay here and in search.</t.Panel>
  </Tabs>
</template>
