import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Tabs, createTabsController } from "ember-ui-sdk/tabs"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  tabs = createTabsController()
  @tracked value: string | null = "inbox"

  showSent = () => this.tabs.select("sent")

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    this.log(`value: ${next} (${details.reason})`)
  }

  <template>
    <div>
      <div data-slot="controls">
        <button type="button" {{on "click" this.showSent}}>Show Sent Mail</button>
      </div>
      <Tabs
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @controller={{this.tabs}}
        as |t|
      >
        <t.List aria-label="Mail">
          <t.Tab @value="inbox">Inbox</t.Tab>
          <t.Tab @value="drafts">Drafts</t.Tab>
          <t.Tab @value="sent">Sent</t.Tab>
          <t.Indicator />
        </t.List>
        <t.Panel @value="inbox">3 unread messages from Hollis Grant and Inès
          Moreau.</t.Panel>
        <t.Panel @value="drafts">2 drafts, the last one edited yesterday at 4:12
          PM.</t.Panel>
        <t.Panel @value="sent">12 messages sent this week, all delivered.</t.Panel>
      </Tabs>
    </div>
  </template>
}
