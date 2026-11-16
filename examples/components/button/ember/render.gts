import Component from "@glimmer/component"
import { Button } from "ember-ui-sdk/button"
import { useLog } from "../../../shared/ember/log"

const wait = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))

export default class Render extends Component {
  log = useLog(this)

  save = async () => {
    await wait(1000)
    this.log("Couldn't save. Check your connection and try again.")
    throw new Error("Couldn't save")
  }

  <template>
    <div data-slot="stack">
      <Button @onClick={{this.save}} @render={{true}} as |b|>
        <button {{b.part}}>
          {{#if b.state.pending}}
            Saving…
          {{else if b.state.error}}
            Try Again
          {{else}}
            Save Changes
          {{/if}}
        </button>
      </Button>
    </div>
  </template>
}
