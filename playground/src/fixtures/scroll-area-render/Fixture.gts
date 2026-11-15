import Component from "@glimmer/component"
import { ScrollArea } from "ember-ui-sdk/scroll-area"

const notes = Array.from({ length: 40 }, (_, index) => `Note ${index + 1}`)
const renders = ((window as unknown as { renders: { root: number } }).renders =
  { root: 0 })

const status = (atEnd: boolean) => {
  renders.root++
  return atEnd ? "At end" : "Reading"
}

export default class ScrollAreaRenderFixture extends Component {
  notes = notes

  <template>
    <div class="fixture">
      <button>Before</button>
      <ScrollArea @render={{true}} as |s|>
        <section {{s.part}} class="scroll-area">
          <p class="render-status">{{status s.state.atEnd}}</p>
          <s.Viewport @render={{true}} as |v|>
            <article
              {{v.part}}
              class="scroll-area-viewport"
              role="region"
              aria-label="Notes"
            >
              {{#each this.notes key="@identity" as |note|}}
                <p class="scroll-area-item">{{note}}</p>
              {{/each}}
            </article>
          </s.Viewport>
          <s.Scrollbar class="scroll-area-scrollbar" as |b|>
            <b.Thumb class="scroll-area-thumb" />
          </s.Scrollbar>
        </section>
      </ScrollArea>
      <button>After</button>
      <output role="status" aria-label="Last action"></output>
    </div>
  </template>
}
