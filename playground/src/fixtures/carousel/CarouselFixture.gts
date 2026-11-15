import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { htmlSafe } from "@ember/template"
import {
  Carousel,
  CarouselNext,
  createCarouselController,
} from "ember-ui-sdk/carousel"
import { carouselFixture, carouselOptions } from "tests/fixtures/carousel.ts"

const plusOne = (index: number) => index + 1
const isThird = (index: number) => index === 2

export default class CarouselFixture extends Component {
  f = carouselFixture
  controller = createCarouselController()
  settings = carouselOptions()
  o = this.settings.options
  plusOne = plusOne
  isThird = isThird
  @tracked page = 1
  @tracked action = ""
  @tracked reason = ""
  @tracked rested = ""

  get style() {
    return htmlSafe(`--per-view: ${this.settings.perView}`)
  }

  get pageValue() {
    return this.settings.controlled ? this.page : undefined
  }

  indicatorLabel = (index: number) => carouselFixture.indicator(index + 1)

  onPageChange = (
    next: number,
    details: { reason: string; cancel: () => void }
  ) => {
    if (next === this.settings.cancel) {
      return details.cancel()
    }
    if (this.settings.controlled) {
      this.page = next
    }
    this.action = String(next)
    this.reason = details.reason
  }

  onPageChangeComplete = (page: number) => (this.rested = String(page))
  showPage4 = () => this.controller.setPage(4)
  showPage3 = () => (this.page = 3)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Carousel
        class="carousel"
        aria-label={{this.f.label}}
        style={{this.style}}
        @slidesPerPage={{this.o.slidesPerPage}}
        @align={{this.o.align}}
        @orientation={{this.o.orientation}}
        @loop={{this.o.loop}}
        @defaultPlaying={{this.o.defaultPlaying}}
        @interval={{this.o.interval}}
        @defaultPage={{this.o.defaultPage}}
        @drag={{this.o.drag}}
        @skipSnaps={{this.o.skipSnaps}}
        @dragFree={{this.o.dragFree}}
        @page={{this.pageValue}}
        @controller={{this.controller}}
        @onPageChange={{this.onPageChange}}
        @onPageChangeComplete={{this.onPageChangeComplete}}
        as |c|
      >
        {{#if this.settings.playToggle}}
          <c.PlayToggle class="carousel-toggle" as |toggle|>
            {{if toggle.state.playing this.f.stop this.f.start}}
          </c.PlayToggle>
        {{/if}}
        <c.Viewport class="carousel-viewport">
          <c.Content class="carousel-content">
            {{#each this.f.slides key="title" as |slide index|}}
              <c.Item class="carousel-slide">
                <p>{{slide.title}}</p>
                <a href="?product={{this.plusOne index}}">{{slide.link}}</a>
                {{#if (this.isThird index)}}
                  <label> {{this.f.field}} <input /></label>
                {{/if}}
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
        <div class="carousel-controls">
          <c.Previous class="carousel-step">{{this.f.previous}}</c.Previous>
          <c.Next class="carousel-step">{{this.f.next}}</c.Next>
        </div>
        <c.IndicatorGroup
          class="carousel-controls"
          aria-label={{this.f.indicators}}
          as |g|
        >
          {{#each this.f.slides key="title" as |slide index|}}
            <g.Indicator
              class="carousel-indicator"
              aria-label={{this.indicatorLabel index}}
            >
              {{this.plusOne index}}
            </g.Indicator>
          {{/each}}
        </c.IndicatorGroup>
      </Carousel>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Last reason">{{this.reason}}</output>
      <output aria-label="Rested on">{{this.rested}}</output>
      <button {{on "click" this.showPage4}}>Show page 4</button>
      {{#if this.settings.controlled}}
        <button {{on "click" this.showPage3}}>Show page 3 by prop</button>
      {{/if}}
      <CarouselNext @controller={{this.controller}}>Next from outside</CarouselNext>
    </div>
  </template>
}
