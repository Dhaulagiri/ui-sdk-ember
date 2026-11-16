import Component from "@glimmer/component"
import { LoaderCircle } from "lucide"
import { Command } from "ember-ui-sdk/command"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const wait = (ms: number) =>
  new Promise<void>((resolve) => setTimeout(resolve, ms))

export default class Pending extends Component {
  log = useLog(this)

  deploy = async () => {
    await wait(1200)
    this.log("Deployed to production")
  }

  sync = async () => {
    await wait(600)
    this.log("Couldn't sync: offline")
    throw new Error("Offline")
  }

  <template>
    <div data-slot="stack">
      <Command as |c|>
        <c.Input aria-label="Search actions" placeholder="Search actions…" />
        <c.List>
          <c.Item @value="deploy" @onSelect={{this.deploy}} as |item|>
            Deploy to production
            {{#if item.state.pending}}
              <span data-slot="spinner">{{icon LoaderCircle}}</span>
            {{/if}}
          </c.Item>
          <c.Item @value="sync" @onSelect={{this.sync}} as |item|>
            Sync with server
            {{#if item.state.pending}}
              <span data-slot="spinner">{{icon LoaderCircle}}</span>
            {{else if item.state.error}}
              <span data-slot="hint">Failed, try again</span>
            {{/if}}
          </c.Item>
        </c.List>
      </Command>
    </div>
  </template>
}
