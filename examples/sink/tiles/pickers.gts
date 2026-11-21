import { htmlSafe } from "@ember/template"
import { guidFor } from "@ember/object/internals"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { TOC } from "@ember/component/template-only"
import {
  contrastRatio,
  formatColor,
  isInGamut,
  mixColor,
  parseColor,
  toGamut,
  type Color,
} from "@ui-sdk/core/color"
import { cropImage } from "@ui-sdk/core/image"
import {
  createElement,
  Check,
  RotateCw,
  Star,
  Truck,
  WandSparkles,
  X,
} from "lucide"
import type { IconNode } from "lucide"
import { Button } from "ember-ui-sdk/button"
import { ColorPicker } from "ember-ui-sdk/color-picker"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"
import { ImageCropper, type ImageCrop } from "ember-ui-sdk/image-cropper"
import { Input } from "ember-ui-sdk/input"
import { Label } from "ember-ui-sdk/label"
import { Rating } from "ember-ui-sdk/rating"
import { TimeInput } from "ember-ui-sdk/time-input"
import "../../../vendor/ui/apps/docs/app/sink/tiles/pickers.css"
import { icon } from "../icon.ts"
import type { Tile } from "../types.ts"

/** A Lucide icon with extra attributes, like a fill, for what Phosphor's fill weight drew. */
const mark = (
  node: IconNode,
  size: number,
  attrs: Record<string, string> = {}
) =>
  createElement(node, {
    "aria-hidden": "true",
    width: String(size),
    height: String(size),
    ...attrs,
  })

const white = parseColor("#fff")!
const black = parseColor("#000")!

const readableInk = (color: Color) =>
  contrastRatio(color, white) >= contrastRatio(color, black) ? white : black

/* 1. Brand color */

const brandPresets = [
  "#e5484d",
  "#f76b15",
  "#ffc53d",
  "#30a46c",
  "#12a594",
  "#0090ff",
  "#6e56cf",
  "#d6409f",
]

class BrandColor extends Component {
  @tracked value = "#6e56cf"
  presets = brandPresets

  setValue = (value: string) => {
    this.value = value
  }

  get siteStyle() {
    const brand = parseColor(this.value) ?? black
    const ink = formatColor(readableInk(brand), "hex")
    const tint = formatColor(mixColor(brand, white, 0.86), "hex")
    return htmlSafe(
      `--pk-brand: ${this.value}; --pk-brand-ink: ${ink}; --pk-brand-tint: ${tint}`
    )
  }

  <template>
    <div class="pk-brand">
      <ColorPicker
        class="pk-picker"
        aria-label="Brand color"
        @format="hex"
        @value={{this.value}}
        @onValueChange={{this.setValue}}
        as |c|
      >
        <c.Area class="pk-area" as |a|>
          <a.Thumb class="pk-thumb" />
        </c.Area>
        <c.Slider @channel="hue" class="pk-slider" as |s|>
          <s.Thumb class="pk-thumb pk-slider-thumb" />
        </c.Slider>
        <div class="pk-hex">
          <c.Swatch class="pk-swatch" />
          <c.Input class="b-input pk-hex-input" aria-label="Hex" />
        </div>
        <c.Swatches class="pk-presets" aria-label="Presets">
          {{#each this.presets key="@identity" as |preset|}}
            <c.SwatchItem @value={{preset}} class="pk-preset" />
          {{/each}}
        </c.Swatches>
      </ColorPicker>

      <div class="pk-site" style={{this.siteStyle}} aria-hidden="true">
        <div class="pk-site-bar">
          <span class="pk-site-logo"></span>
          <span class="pk-site-name">Fieldnote</span>
          <span class="pk-site-link">Pricing</span>
        </div>
        <span class="pk-site-badge">New · Shared notebooks</span>
        <p class="pk-site-head">Notes your whole team can find.</p>
        <div class="pk-site-actions">
          <span class="pk-site-cta">Start free</span>
          <span class="pk-site-more">Book a demo</span>
        </div>
      </div>
    </div>
  </template>
}

/* 2. Contrast check */

const levels = [
  { name: "AA Large", min: 3 },
  { name: "AA", min: 4.5 },
  { name: "AAA", min: 7 },
]

function liftContrast(text: Color, ground: Color, target: number) {
  const toward = readableInk(ground)
  const hexAt = (amount: number) =>
    formatColor(toGamut(mixColor(text, toward, amount)), "hex")
  let low = 0
  let high = 1
  for (let step = 0; step < 16; step++) {
    const middle = (low + high) / 2
    if (contrastRatio(parseColor(hexAt(middle))!, ground) >= target) {
      high = middle
    } else {
      low = middle
    }
  }
  return hexAt(high)
}

const notColor = (value: string) => !parseColor(value)

const dotStyle = (value: string) => {
  const color = parseColor(value)
  return htmlSafe(`background: ${color ? formatColor(color) : "transparent"}`)
}

const ColorField: TOC<{
  Args: {
    label: string
    value: string
    onValueChange: (value: string) => void
  }
}> = <template>
  <Field class="pk-color-field" @invalid={{notColor @value}} as |f|>
    <f.Label class="b-label">{{@label}}</f.Label>
    <div class="b-input pk-color-input">
      <span class="pk-dot" style={{dotStyle @value}}></span>
      <Input
        class="pk-bare"
        @field={{f.field}}
        @value={{@value}}
        @onValueChange={{@onValueChange}}
        spellcheck="false"
        autocomplete="off"
      />
    </div>
  </Field>
</template>

class ColorText {
  @tracked text: string
  @tracked color: Color

  constructor(initial: string) {
    this.text = initial
    this.color = parseColor(initial)!
  }

  update = (next: string) => {
    this.text = next
    const parsed = parseColor(next)
    if (parsed) {
      this.color = parsed
    }
  }
}

class ContrastCheck extends Component {
  fore = new ColorText("#8b8d98")
  back = new ColorText("#fdfcf9")

  get ratio() {
    return contrastRatio(this.fore.color, this.back.color)
  }

  get passesAA() {
    return this.ratio >= 4.5
  }

  get isWide() {
    return !isInGamut(this.fore.color) || !isInGamut(this.back.color)
  }

  get sampleStyle() {
    return htmlSafe(
      `background: ${formatColor(this.back.color)}; color: ${formatColor(this.fore.color)}`
    )
  }

  get ratioText() {
    return this.ratio.toFixed(2)
  }

  get rows() {
    return levels.map((level) => ({
      name: level.name,
      passes: this.ratio >= level.min,
    }))
  }

  get note() {
    return this.isWide
      ? "Outside sRGB; checked as given."
      : this.passesAA
        ? "Body text reads clearly."
        : "Too faint for body text."
  }

  fix = () => {
    this.fore.update(liftContrast(this.fore.color, this.back.color, 4.5))
  }

  passIcon = () =>
    mark(Check, 12, {
      "aria-label": "Passes",
      "aria-hidden": "false",
      role: "img",
    })
  failIcon = () =>
    mark(X, 12, { "aria-label": "Fails", "aria-hidden": "false", role: "img" })

  <template>
    <div class="pk-contrast">
      <div class="pk-sample" style={{this.sampleStyle}}>
        <p class="pk-sample-head">Your order is on its way.</p>
        <p class="pk-sample-body">
          Track it any time from Orders. We’ll text you when it’s close.
        </p>
      </div>

      <div class="pk-score">
        <p class="pk-ratio" aria-live="polite">
          {{this.ratioText}}<span class="pk-ratio-unit">: 1</span>
        </p>
        <ul class="pk-levels" aria-label="WCAG levels">
          {{#each this.rows key="name" as |level|}}
            <li class="pk-level" data-pass={{if level.passes ""}}>
              {{#if
                level.passes
              }}{{this.passIcon}}{{else}}{{this.failIcon}}{{/if}}
              {{level.name}}
            </li>
          {{/each}}
        </ul>
      </div>

      <div class="pk-color-fields">
        <ColorField
          @label="Text"
          @value={{this.fore.text}}
          @onValueChange={{this.fore.update}}
        />
        <ColorField
          @label="Background"
          @value={{this.back.text}}
          @onValueChange={{this.back.update}}
        />
      </div>

      <div class="pk-contrast-foot">
        <p class="pk-note">{{this.note}}</p>
        <Button
          class="b-btn"
          data-variant="primary"
          @disabled={{this.passesAA}}
          @onClick={{this.fix}}
        >
          {{icon WandSparkles 14}}
          Fix text
        </Button>
      </div>
    </div>
  </template>
}

/* 3. Avatar crop */

const portrait = `data:image/svg+xml,${encodeURIComponent(
  `<svg xmlns="http://www.w3.org/2000/svg" width="720" height="480"><defs><linearGradient id="s" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#ffb38a"/><stop offset=".6" stop-color="#ff7a59"/><stop offset="1" stop-color="#c2410c"/></linearGradient><linearGradient id="h" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#3b2a20"/><stop offset="1" stop-color="#1c130e"/></linearGradient></defs><rect width="720" height="480" fill="url(#s)"/><circle cx="560" cy="120" r="48" fill="#fff4e6" opacity=".85"/><path d="M0 360 140 280l120 70 140-110 160 120 160-80v220H0z" fill="#9a3412" opacity=".55"/><path d="M250 480c10-90 60-140 110-150h0c50 10 100 60 110 150z" fill="#1e3a8a"/><rect x="335" y="270" width="50" height="70" rx="20" fill="#e8a27c"/><ellipse cx="360" cy="220" rx="62" ry="74" fill="#f2b591"/><path d="M296 214c-4-60 30-98 68-98 44 0 72 34 66 96-10-30-28-46-50-52-30 16-60 24-84 54z" fill="url(#h)"/><circle cx="338" cy="226" r="5" fill="#2a1a12"/><circle cx="384" cy="226" r="5" fill="#2a1a12"/><path d="M344 258q16 12 32 0" stroke="#9a4a2e" stroke-width="4" fill="none" stroke-linecap="round"/></svg>`
)}`

class AvatarCrop extends Component {
  portrait = portrait
  @tracked crop: ImageCrop | undefined = undefined
  @tracked avatar: string | undefined = undefined
  @tracked isSaving = false

  onCropChange = (next: ImageCrop) => {
    this.crop = next
  }

  get cannotSave() {
    return !this.crop || this.isSaving
  }

  get status() {
    return this.avatar ? "Photo updated" : "No photo yet"
  }

  save = async () => {
    if (!this.crop) {
      return
    }
    this.isSaving = true
    const file = await cropImage(portrait, this.crop, {
      width: 160,
      shape: "circle",
    })
    if (this.avatar) {
      URL.revokeObjectURL(this.avatar)
    }
    this.avatar = URL.createObjectURL(file)
    this.isSaving = false
  }

  willDestroy() {
    super.willDestroy()
    if (this.avatar) {
      URL.revokeObjectURL(this.avatar)
    }
  }

  <template>
    <ImageCropper
      class="pk-cropper"
      aria-label="Profile photo"
      @src={{this.portrait}}
      @mode="frame"
      @aspectRatio={{1}}
      @shape="circle"
      @maxZoom={{4}}
      @crop={{this.crop}}
      @onCropChange={{this.onCropChange}}
      as |c|
    >
      <c.Viewport class="pk-viewport">
        <c.Image class="pk-image" alt="Portrait at sunset" />
        <c.Selection class="pk-selection" />
      </c.Viewport>
      <div class="pk-crop-side">
        <div class="pk-profile">
          {{#if this.avatar}}
            <img class="pk-avatar" src={{this.avatar}} alt="Your new avatar" />
          {{else}}
            <span class="pk-avatar" data-empty="">MO</span>
          {{/if}}
          <div class="pk-profile-text">
            <p class="pk-profile-name">Maya Okafor</p>
            <p class="pk-profile-meta">{{this.status}}</p>
          </div>
        </div>
        <label class="pk-zoom">
          <span class="b-label">Zoom</span>
          <c.Zoom class="pk-zoom-range" />
        </label>
        <div class="pk-crop-actions">
          <c.Rotate class="b-btn pk-icon-btn" aria-label="Rotate">
            {{icon RotateCw 15}}
          </c.Rotate>
          <Button
            class="b-btn pk-save"
            data-variant="primary"
            @disabled={{this.cannotSave}}
            @onClick={{this.save}}
          >
            Save photo
          </Button>
        </div>
      </div>
    </ImageCropper>
  </template>
}

/* 4. Pickup time */

const pickupFormat = new Intl.DateTimeFormat("en-US", {
  weekday: "short",
  month: "short",
  day: "numeric",
})
const pickupTimeFormat = new Intl.DateTimeFormat("en-US", {
  hour: "numeric",
  minute: "2-digit",
})

const deskOpens = "06:00"
const deskCloses = "23:00"

function pickupSummary(date: string | null, time: string | null) {
  if (!date || !time) {
    return "Pick a day and time."
  }
  if (time < deskOpens || time > deskCloses) {
    return "The desk is open 6 AM to 11 PM."
  }
  const at = new Date(`${date}T${time}`)
  return `${pickupFormat.format(at)} at ${pickupTimeFormat.format(at)}`
}

class PickupTime extends Component {
  @tracked date: string | null = "2026-11-20"
  @tracked time: string | null = "14:30"

  setDate = (value: string | null) => {
    this.date = value
  }
  setTime = (value: string | null) => {
    this.time = value
  }

  get summary() {
    return pickupSummary(this.date, this.time)
  }

  <template>
    <div class="pk-pickup">
      <p class="pk-pickup-place">
        {{icon Truck 16}}
        Lisbon Airport, Terminal 1
      </p>
      <div class="pk-pickup-fields">
        <Field class="pk-pickup-field" as |f|>
          <f.Label class="b-label">Date</f.Label>
          <DateInput
            class="b-input pk-segments"
            @min="2026-11-18"
            @value={{this.date}}
            @onValueChange={{this.setDate}}
            @field={{f.field}}
          />
        </Field>
        <Field class="pk-pickup-field" as |f|>
          <f.Label class="b-label">Time</f.Label>
          <TimeInput
            class="b-input pk-segments"
            @value={{this.time}}
            @onValueChange={{this.setTime}}
            @field={{f.field}}
          />
        </Field>
      </div>
      <p class="pk-pickup-summary" aria-live="polite">{{this.summary}}</p>
    </div>
  </template>
}

/* 5. Stay rating */

const ratingWords = ["", "Poor", "Fair", "Good", "Very good", "Superb"]
const aspects = [
  { name: "Cleanliness", value: 4 },
  { name: "Location", value: 5 },
]

const solidStar = (size: number) => mark(Star, size, { fill: "currentColor" })
const solidStarFill = (size: number) =>
  mark(Star, size, { fill: "currentColor", class: "pk-star-fill" })

class StayRating extends Component {
  id = guidFor(this)
  aspects = aspects
  @tracked overall: number | null = 4.5

  setOverall = (value: number | null) => {
    this.overall = value
  }

  get word() {
    return this.overall
      ? ratingWords[Math.max(1, Math.floor(this.overall))]
      : "Not rated"
  }

  <template>
    <div class="pk-stay">
      <div class="pk-stay-row" data-main="">
        <Label class="pk-stay-label" for="{{this.id}}-overall">Overall</Label>
        <span class="pk-stay-word">{{this.word}}</span>
      </div>
      <Rating
        class="pk-rating"
        @id="{{this.id}}-overall"
        @step={{0.5}}
        @value={{this.overall}}
        @onValueChange={{this.setOverall}}
        as |r|
      >
        <r.Item class="pk-star">
          {{solidStar 28}}
          {{solidStarFill 28}}
        </r.Item>
      </Rating>
      <div class="pk-stay-aspects">
        {{#each this.aspects key="name" as |aspect|}}
          <div class="pk-stay-row">
            <Label class="pk-stay-label" for="{{this.id}}-{{aspect.name}}">
              {{aspect.name}}
            </Label>
            <Rating
              class="pk-rating"
              data-small=""
              @id="{{this.id}}-{{aspect.name}}"
              @defaultValue={{aspect.value}}
              as |r|
            >
              <r.Item class="pk-star">
                {{solidStar 16}}
                {{solidStarFill 16}}
              </r.Item>
            </Rating>
          </div>
        {{/each}}
      </div>
    </div>
  </template>
}

export const tiles: Tile[] = [
  {
    id: "forms-brand-color",
    title: "Pick the brand color.",
    blurb: "Drag, paste a hex or tap a preset; the site follows.",
    size: "large",
    Demo: BrandColor,
  },
  {
    id: "forms-contrast",
    title: "Will it pass AA?",
    blurb: "Any CSS color in, a WCAG ratio out.",
    size: "tall",
    tone: "paper",
    Demo: ContrastCheck,
  },
  {
    id: "forms-avatar-crop",
    title: "Frame your avatar.",
    blurb: "Drag to pan, scroll to zoom, then save.",
    size: "wide",
    tone: "ink",
    Demo: AvatarCrop,
  },
  {
    id: "forms-pickup-time",
    title: "Set the pickup time.",
    blurb: "Type or arrow through each part.",
    tone: "sky",
    Demo: PickupTime,
  },
  {
    id: "forms-stay-rating",
    title: "Rate your stay.",
    blurb: "Half stars by pointer or arrow keys.",
    tone: "butter",
    Demo: StayRating,
  },
]
