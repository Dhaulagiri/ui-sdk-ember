import Component from "@glimmer/component"
import { Carousel } from "ember-ui-sdk/carousel"
import { ChevronLeft, ChevronRight } from "lucide"
import { attach } from "ember-ui-sdk/primitive"
import { icon } from "../../../shared/ember/icon"

const photos = [
  { name: "Dunes" },
  { name: "Forest" },
  { name: "Glacier" },
  { name: "Canyon" },
  { name: "Meadow" },
  { name: "Harbor" },
]

const position = (index: number) => index + 1

export default class Render extends Component {
  photos = photos
  nextFocused = false

  rememberFocus = () => {
    this.nextFocused =
      document.activeElement?.getAttribute("data-slot") === "carousel-next"
  }

  focusIf = (link: HTMLElement) => {
    if (this.nextFocused) {
      link.focus()
    }
  }

  <template>
    <Carousel aria-label="Photos" @onPageChange={{this.rememberFocus}} as |c|>
      <c.Viewport>
        <c.Content>
          {{#each this.photos key="name" as |photo|}}
            <c.Item as |item|>
              <div data-slot="tile">
                {{photo.name}}
                <span data-slot="hint">
                  {{position item.state.index}}
                  /
                  {{this.photos.length}}{{if item.state.active " · showing"}}
                </span>
              </div>
            </c.Item>
          {{/each}}
        </c.Content>
      </c.Viewport>
      <div data-slot="row">
        <c.Previous>
          {{icon ChevronLeft}}
          Previous
        </c.Previous>
        <c.Next @render={{true}} as |next|>
          {{#if next.state.disabled}}
            <a {{attach this.focusIf}} href="https://example.com/gallery">See
              all photos</a>
          {{else}}
            <button {{next.part}}>
              Next
              {{icon ChevronRight}}
            </button>
          {{/if}}
        </c.Next>
      </div>
    </Carousel>
  </template>
}
