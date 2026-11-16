import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Carousel } from "ember-ui-sdk/carousel"

const photos = [
  { name: "Dunes" },
  { name: "Forest" },
  { name: "Glacier" },
  { name: "Canyon" },
  { name: "Meadow" },
  { name: "Harbor" },
]

export default class Thumbnails extends Component {
  photos = photos
  @tracked page = 1

  onPageChange = (next: number) => {
    this.page = next
    const block = document.querySelector("#thumbnails-block")
    block
      ?.querySelectorAll("button")
      [next - 1]?.scrollIntoView({ block: "nearest", inline: "nearest" })
  }

  choose = (index: number) => {
    this.page = index + 1
  }

  isActive = (index: number) => String(this.page === index + 1)

  <template>
    <div id="thumbnails-block" data-slot="stack">
      <Carousel
        aria-label="Photos"
        @page={{this.page}}
        @onPageChange={{this.onPageChange}}
        as |c|
      >
        <c.Viewport>
          <c.Content>
            {{#each this.photos key="name" as |photo|}}
              <c.Item>
                <div data-slot="tile">
                  {{photo.name}}
                </div>
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
      </Carousel>
      <Carousel
        aria-label="Thumbnails"
        @dragFree={{true}}
        @slidesPerPage="auto"
        as |c|
      >
        <c.Viewport>
          <c.Content>
            {{#each this.photos key="name" as |photo index|}}
              <c.Item aria-label={{photo.name}}>
                <button
                  type="button"
                  aria-pressed={{this.isActive index}}
                  {{on "click" (fn this.choose index)}}
                >
                  {{photo.name}}
                </button>
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
      </Carousel>
    </div>
  </template>
}
