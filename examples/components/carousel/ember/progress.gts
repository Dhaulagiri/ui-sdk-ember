import Component from "@glimmer/component"
import { ChevronLeft, ChevronRight } from "lucide"
import { Carousel } from "ember-ui-sdk/carousel"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const slides = [1, 2, 3, 4, 5]

export default class Progress extends Component {
  log = useLog(this)
  slides = slides

  onPageChangeComplete = (page: number) => {
    this.log(`Rested on slide ${page}`)
  }

  <template>
    <Carousel
      aria-label="Featured"
      @onPageChangeComplete={{this.onPageChangeComplete}}
      as |c|
    >
      <div data-slot="row">
        <c.Previous aria-label="Previous slide">{{icon
            ChevronLeft
          }}</c.Previous>
        <c.Viewport>
          <c.Content>
            {{#each this.slides key="@identity" as |slide|}}
              <c.Item>
                <div data-slot="tile">{{slide}}</div>
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
        <c.Next aria-label="Next slide">{{icon ChevronRight}}</c.Next>
      </div>
      <div data-slot="row">
        <div data-slot="bar">
          <div></div>
        </div>
      </div>
    </Carousel>
  </template>
}
