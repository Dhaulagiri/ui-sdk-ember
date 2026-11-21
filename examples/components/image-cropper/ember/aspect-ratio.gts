import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { ImageCropper } from "ember-ui-sdk/image-cropper"

const photo = `data:image/svg+xml,${encodeURIComponent(
  `<svg xmlns="http://www.w3.org/2000/svg" width="640" height="420"><rect width="640" height="420" fill="#e5e5e5"/><circle cx="460" cy="150" r="56" fill="#fafafa"/><path d="M0 280 120 170l110 100 120-130 130 125 90-60 70 40v175H0z" fill="#a3a3a3"/><path d="M0 330l160-80 120 70 150-80 210 85v95H0z" fill="#525252"/><path d="M0 380q160-35 320-10t320-5v55H0z" fill="#262626"/></svg>`
)}`

const ratios = [
  { label: "Free", value: undefined },
  { label: "Square", value: 1 },
  { label: "Wide", value: 16 / 9 },
]

const handles = ["nw", "n", "ne", "e", "se", "s", "sw", "w"]

export default class AspectRatio extends Component {
  photo = photo
  ratios = ratios
  handles = handles
  @tracked aspectRatio: number | undefined = undefined

  pick = (value: number | undefined) => {
    this.aspectRatio = value
  }

  pressed = (value: number | undefined) => String(this.aspectRatio === value)

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        {{#each this.ratios key="label" as |ratio|}}
          <button
            type="button"
            aria-pressed={{this.pressed ratio.value}}
            {{on "click" (fn this.pick ratio.value)}}
          >
            {{ratio.label}}
          </button>
        {{/each}}
      </div>
      <ImageCropper
        @src={{this.photo}}
        @aspectRatio={{this.aspectRatio}}
        @minWidth={{64}}
        @minHeight={{64}}
        aria-label="Photo"
        as |c|
      >
        <c.Viewport>
          <c.Image alt="Mountains at sunset" />
          <c.Selection>
            <c.Grid />
          </c.Selection>
          {{#each this.handles key="@identity" as |position|}}
            <c.Handle @position={{position}} />
          {{/each}}
        </c.Viewport>
      </ImageCropper>
    </div>
  </template>
}
