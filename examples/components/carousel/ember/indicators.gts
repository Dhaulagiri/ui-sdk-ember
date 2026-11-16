import Component from "@glimmer/component"
import { Carousel } from "ember-ui-sdk/carousel"

const photos = [
  { name: "Dunes" },
  { name: "Forest" },
  { name: "Glacier" },
  { name: "Canyon" },
  { name: "Meadow" },
  { name: "Harbor" },
]

export default class Indicators extends Component {
  photos = photos

  pageOf = (index: number) => index + 1

  <template>
    <Carousel aria-label="Photos" as |c|>
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
      <c.IndicatorGroup aria-label="Choose a photo" as |g|>
        {{#each this.photos key="name" as |photo index|}}
          <g.Indicator @page={{this.pageOf index}} aria-label={{photo.name}} />
        {{/each}}
      </c.IndicatorGroup>
    </Carousel>
  </template>
}
