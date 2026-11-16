import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { ChevronLeft, ChevronRight } from "lucide"
import {
  Carousel,
  CarouselNext,
  CarouselPrevious,
  createCarouselController,
} from "ember-ui-sdk/carousel"
import { icon } from "../../../shared/ember/icon"

const slides = [1, 2, 3, 4, 5]

export default class ControllerExample extends Component {
  slides = slides
  carousel = createCarouselController()

  showLast = () => {
    this.carousel.setPage(5)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <CarouselPrevious
          @controller={{this.carousel}}
          aria-label="Previous slide"
        >{{icon ChevronLeft}}</CarouselPrevious>
        <CarouselNext
          @controller={{this.carousel}}
          aria-label="Next slide"
        >{{icon ChevronRight}}</CarouselNext>
        <button type="button" {{on "click" this.showLast}}>Show the Last Slide</button>
      </div>
      <Carousel
        aria-label="Featured"
        @controller={{this.carousel}}
        @drag={{false}}
        as |c|
      >
        <c.Viewport>
          <c.Content>
            {{#each this.slides key="@identity" as |slide|}}
              <c.Item>
                <div data-slot="tile">{{slide}}</div>
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
      </Carousel>
    </div>
  </template>
}
