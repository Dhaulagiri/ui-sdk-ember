import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Carousel } from "ember-ui-sdk/carousel"

const plusOne = (index: number) => index + 1

export default class Fixture extends Component {
  slides = ["One", "Two", "Three"]
  plusOne = plusOne
  @tracked action = ""

  onPageChange = (page: number) => (this.action = String(page))

  <template>
    <div class="fixture">
      <button>Before</button>
      <Carousel
        class="carousel"
        aria-label="Photos"
        @onPageChange={{this.onPageChange}}
        as |c|
      >
        <c.Viewport class="carousel-viewport">
          <c.Content>
            {{#each this.slides as |slide|}}
              <c.Item class="carousel-slide" as |item|>
                <span
                  class={{if item.state.active "is-active" "is-inactive"}}
                >{{slide}}</span>
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
        <c.Next @render={{true}} as |next|>
          <button {{next.part}}>{{if
              next.state.disabled
              "No more photos"
              "Next photo"
            }}</button>
        </c.Next>
        <c.IndicatorGroup aria-label="Choose a photo" as |g|>
          {{#each this.slides as |slide index|}}
            <g.Indicator @render={{true}} as |indicator|>
              <a
                href="#photo-{{this.plusOne index}}"
                aria-label="Photo {{this.plusOne index}}"
                {{indicator.part}}
              >
                {{this.plusOne index}}
              </a>
            </g.Indicator>
          {{/each}}
        </c.IndicatorGroup>
      </Carousel>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
