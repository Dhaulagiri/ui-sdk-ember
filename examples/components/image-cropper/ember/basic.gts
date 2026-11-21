import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { cropImage, type ImageCrop } from "@ui-sdk/core/image"
import { ImageCropper } from "ember-ui-sdk/image-cropper"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const photo = `data:image/svg+xml,${encodeURIComponent(
  `<svg xmlns="http://www.w3.org/2000/svg" width="640" height="420"><rect width="640" height="420" fill="#e5e5e5"/><circle cx="460" cy="150" r="56" fill="#fafafa"/><path d="M0 280 120 170l110 100 120-130 130 125 90-60 70 40v175H0z" fill="#a3a3a3"/><path d="M0 330l160-80 120 70 150-80 210 85v95H0z" fill="#525252"/><path d="M0 380q160-35 320-10t320-5v55H0z" fill="#262626"/></svg>`
)}`

const ratios = [
  { value: "free", label: "Free", ratio: undefined },
  { value: "square", label: "Square", ratio: 1 },
  { value: "landscape", label: "4:3", ratio: 4 / 3 },
  { value: "wide", label: "16:9", ratio: 16 / 9 },
]

const handles = ["nw", "n", "ne", "e", "se", "s", "sw", "w"]

export default class Basic extends Component {
  photo = photo
  ratios = ratios
  handles = handles
  @tracked ratio: string | null = "free"
  @tracked crop: ImageCrop | undefined = undefined
  @tracked result: string | undefined = undefined

  get aspectRatio() {
    return this.ratios.find((item) => item.value === this.ratio)?.ratio
  }

  onRatioChange = (next: string | null) => {
    this.ratio = next
  }

  onCropChange = (next: ImageCrop) => {
    this.crop = next
  }

  save = async () => {
    if (!this.crop) {
      return
    }
    const file = await cropImage(photo, this.crop)
    if (this.result) {
      URL.revokeObjectURL(this.result)
    }
    this.result = URL.createObjectURL(file)
  }

  willDestroy() {
    super.willDestroy()
    if (this.result) {
      URL.revokeObjectURL(this.result)
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select
          @value={{this.ratio}}
          @onValueChange={{this.onRatioChange}}
          as |s|
        >
          <s.Trigger aria-label="Aspect ratio">
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.ratios key="value" as |item|}}
              <s.Item @value={{item.value}} as |entry|>
                {{item.label}}
                <entry.Indicator>{{icon Check}}</entry.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <button
          type="button"
          data-variant="solid"
          {{on "click" this.save}}
        >Crop</button>
      </div>
      <ImageCropper
        @crop={{this.crop}}
        @onCropChange={{this.onCropChange}}
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
      <div data-slot="image-cropper-result">
        {{#if this.result}}
          <img src={{this.result}} alt="Your crop" />
        {{/if}}
      </div>
    </div>
  </template>
}
