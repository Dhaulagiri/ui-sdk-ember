import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  createNumberInputController,
  NumberInput,
  NumberInputScrubArea,
} from "ember-ui-sdk/number-input"
import { numberInputScrubFixture as f } from "tests/fixtures/number-input-scrub.ts"

export default class NumberInputScrubFixture extends Component {
  f = f
  controller = createNumberInputController()
  @tracked action = ""
  @tracked commits: string[] = []

  get committed() {
    return this.commits.join(" ")
  }

  onValueChange = (value: number | null) => (this.action = String(value))
  onValueCommit = (value: number | null) =>
    (this.commits = [...this.commits, String(value)])

  <template>
    <div class="fixture">
      <button>Before</button>
      <div role="toolbar" aria-label={{this.f.toolbarLabel}} class="row">
        <NumberInputScrubArea
          @controller={{this.controller}}
          class="number-input-scrub"
        >{{this.f.toolbarScrub}}</NumberInputScrubArea>
      </div>
      <table>
        <thead>
          <tr>
            <NumberInputScrubArea
              @controller={{this.controller}}
              @render={{true}}
              as |s|
            >
              <th
                {{s.part}}
                class="number-input-scrub"
              >{{this.f.headerScrub}}</th>
            </NumberInputScrubArea>
          </tr>
        </thead>
      </table>
      <NumberInput
        id={{this.f.id}}
        @controller={{this.controller}}
        @defaultValue={{this.f.defaultValue}}
        @min={{this.f.min}}
        @max={{this.f.max}}
        @locale="en-US"
        @onValueChange={{this.onValueChange}}
        @onValueCommit={{this.onValueCommit}}
        as |n|
      >
        <n.Group class="number-input-group">
          <n.ScrubArea
            class="number-input-scrub"
          >{{this.f.letterScrub}}</n.ScrubArea>
          <n.Control aria-label={{this.f.label}} class="number-input-control" />
        </n.Group>
        <div>
          <div>
            <div>
              <n.ScrubArea
                class="number-input-scrub"
              >{{this.f.nestedScrub}}</n.ScrubArea>
            </div>
          </div>
        </div>
      </NumberInput>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Committed">{{this.committed}}</output>
    </div>
  </template>
}
