import Component from "@glimmer/component"
import { ChevronLeft, ChevronRight } from "lucide"
import { Carousel } from "ember-ui-sdk/carousel"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const photos = [
  { name: "Dunes" },
  { name: "Forest" },
  { name: "Glacier" },
  { name: "Canyon" },
  { name: "Meadow" },
  { name: "Harbor" },
]

export default class Autoplay extends Component {
  log = useLog(this)
  photos = photos

  onPlayingChange = (playing: boolean, details: { reason: string }) => {
    this.log(`${playing ? "Playing" : "Stopped"} (${details.reason})`)
  }

  <template>
    <Carousel
      aria-label="Photos"
      @defaultPlaying={{true}}
      @interval={{4000}}
      @onPlayingChange={{this.onPlayingChange}}
      as |c|
    >
      <div data-slot="controls">
        <c.PlayToggle as |t|>{{if
            t.state.playing
            "Pause"
            "Play"
          }}</c.PlayToggle>
      </div>
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
  </template>
}
