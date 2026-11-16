import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown, ChevronLeft, ChevronRight } from "lucide"
import { Select } from "ember-ui-sdk/select"
import { Carousel } from "ember-ui-sdk/carousel"
import { icon } from "../../../shared/ember/icon"

const photos = [
  { name: "Dunes" },
  { name: "Forest" },
  { name: "Glacier" },
  { name: "Canyon" },
  { name: "Meadow" },
  { name: "Harbor" },
]

const alignments = [
  { value: "start", label: "Start" },
  { value: "center", label: "Center" },
  { value: "end", label: "End" },
]

export default class Align extends Component {
  photos = photos
  alignments = alignments
  @tracked align: "start" | "center" | "end" = "center"

  onAlignChange = (next: string | null) => {
    if (next) this.align = next as "start" | "center" | "end"
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select
          @items={{this.alignments}}
          @value={{this.align}}
          @onValueChange={{this.onAlignChange}}
          as |s|
        >
          <s.Label>Align</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.alignments key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <Carousel
        aria-label="Photos"
        @align={{this.align}}
        @defaultPage={{2}}
        as |c|
      >
        <div data-slot="row">
          <c.Previous aria-label="Previous slide">{{icon
              ChevronLeft
            }}</c.Previous>
          <c.Viewport>
            <c.Content>
              {{#each this.photos key="name" as |photo|}}
                <c.Item>
                  <div data-slot="tile">{{photo.name}}</div>
                </c.Item>
              {{/each}}
            </c.Content>
          </c.Viewport>
          <c.Next aria-label="Next slide">{{icon ChevronRight}}</c.Next>
        </div>
      </Carousel>
    </div>
  </template>
}
