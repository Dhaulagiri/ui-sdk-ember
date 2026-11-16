import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Accordion, createAccordionController } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const items = [
  {
    value: "account",
    label: "Account",
    content: "Your name, email address and profile photo.",
  },
  {
    value: "security",
    label: "Security",
    content: "Your password, passkeys and two-factor authentication.",
  },
  {
    value: "sessions",
    label: "Sessions",
    content: "Devices signed in to your account in the last 30 days.",
  },
]

export default class Controlled extends Component {
  accordion = createAccordionController()
  @tracked value: string[] = ["account"]

  reviewSecurity = () => this.accordion.open("security")

  onValueChange = (next: string[]) => {
    this.value = next
  }

  confirmClose = (
    item: string,
    open: boolean,
    details: { cancel: () => void }
  ) => {
    if (
      !open &&
      item === "security" &&
      !window.confirm("Close the security settings?")
    ) {
      details.cancel()
    }
  }

  <template>
    <div>
      <div data-slot="controls">
        <button type="button" {{on "click" this.reviewSecurity}}>Review security</button>
      </div>
      <Accordion
        @multiple={{true}}
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @controller={{this.accordion}}
        as |a|
      >
        {{#each items key="value" as |item|}}
          <a.Item
            @value={{item.value}}
            @onOpenChange={{fn this.confirmClose item.value}}
            as |i|
          >
            <i.Header>
              <i.Trigger>
                {{item.label}}
                {{icon ChevronDown}}
              </i.Trigger>
            </i.Header>
            <i.Panel>{{item.content}}</i.Panel>
          </a.Item>
        {{/each}}
      </Accordion>
    </div>
  </template>
}
