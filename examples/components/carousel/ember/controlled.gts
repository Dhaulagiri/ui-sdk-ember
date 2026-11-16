import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronLeft, ChevronRight } from "lucide"
import { Carousel } from "ember-ui-sdk/carousel"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const slides = [1, 2, 3, 4, 5]

export default class Controlled extends Component {
  log = useLog(this)
  slides = slides
  @tracked page = 1

  onPageChange = (next: number, details: { reason: string }) => {
    this.page = next
    this.log(`Page ${next} (${details.reason})`)
  }

  <template>
    <Carousel
      aria-label="Featured"
      @page={{this.page}}
      @onPageChange={{this.onPageChange}}
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
    </Carousel>
  </template>
}
