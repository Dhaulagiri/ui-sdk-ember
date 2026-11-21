import { htmlSafe } from "@ember/template"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  AlignCenter,
  AlignLeft,
  AlignRight,
  Bluetooth,
  Bold,
  Italic,
  Underline,
  Volume1,
  Volume2,
  Wifi,
} from "lucide"
import { Meter } from "ember-ui-sdk/meter"
import { Slider } from "ember-ui-sdk/slider"
import { Switch } from "ember-ui-sdk/switch"
import { Toggle, ToggleGroup } from "ember-ui-sdk/toggle"
import { Toolbar } from "ember-ui-sdk/toolbar"
import "../../../vendor/ui/apps/docs/app/sink/tiles/reference.css"
import { icon } from "../icon.ts"
import type { Tile } from "../types.ts"

const rows = [
  { label: "Wi-Fi", detail: "Studio 5G", icon: Wifi, on: true },
  { label: "Bluetooth", detail: "AirPods Pro", icon: Bluetooth, on: false },
]

const Radios = <template>
  <div class="ref-radios">
    {{#each rows as |row|}}
      <label class="ref-radio">
        <span class="ref-radio-icon">{{icon row.icon}}</span>
        <span class="ref-radio-text">
          <span>{{row.label}}</span>
          <span class="ref-radio-detail">{{row.detail}}</span>
        </span>
        <Switch class="ref-switch" @defaultChecked={{row.on}} as |s|>
          <s.Thumb class="ref-switch-thumb" />
        </Switch>
      </label>
    {{/each}}
  </div>
</template>

const Storage = <template>
  <div class="ref-storage">
    <p class="ref-storage-lead">Using</p>
    <p class="ref-storage-number">14.2<span> GB</span></p>
    <Meter @value={{71}} aria-label="Storage used" class="ref-meter" as |m|>
      <m.Track class="ref-meter-track">
        <m.Indicator class="ref-meter-fill" />
      </m.Track>
    </Meter>
    <p class="ref-storage-of">of 20 GB on your plan</p>
  </div>
</template>

class Volume extends Component {
  @tracked volume = 64

  onValueChange = (value: number | readonly number[]) => {
    this.volume = value as number
  }

  <template>
    <div class="ref-volume">
      <Slider
        @value={{this.volume}}
        @onValueChange={{this.onValueChange}}
        class="ref-slider"
        as |s|
      >
        {{icon Volume1}}
        <s.Control class="ref-slider-control">
          <s.Track class="ref-slider-track">
            <s.Indicator class="ref-slider-fill" />
            <s.Thumb aria-label="Volume" class="ref-slider-thumb" />
          </s.Track>
        </s.Control>
        {{icon Volume2}}
      </Slider>
      <p class="ref-volume-value">{{this.volume}}%</p>
    </div>
  </template>
}

class Formatting extends Component {
  @tracked marks = ["bold"]
  @tracked align = ["left"]

  setMarks = (value: string[]) => {
    this.marks = value
  }
  setAlign = (value: string[]) => {
    this.align = value
  }

  get style() {
    const { marks } = this
    return htmlSafe(
      `font-weight: ${marks.includes("bold") ? 600 : 400};` +
        `font-style: ${marks.includes("italic") ? "italic" : "normal"};` +
        `text-decoration: ${marks.includes("underline") ? "underline" : "none"};` +
        `text-align: ${this.align[0]}`
    )
  }

  <template>
    <div class="ref-format">
      <Toolbar aria-label="Formatting" class="ref-toolbar" as |tb|>
        <tb.ToggleGroup
          @multiple={{true}}
          aria-label="Text style"
          @value={{this.marks}}
          @onValueChange={{this.setMarks}}
          class="ref-group"
          as |g|
        >
          <g.Toggle @value="bold" aria-label="Bold" class="ref-tool">{{icon
              Bold
            }}</g.Toggle>
          <g.Toggle @value="italic" aria-label="Italic" class="ref-tool">{{icon
              Italic
            }}</g.Toggle>
          <g.Toggle
            @value="underline"
            aria-label="Underline"
            class="ref-tool"
          >{{icon Underline}}</g.Toggle>
        </tb.ToggleGroup>
        <tb.Separator class="ref-sep" />
        <tb.ToggleGroup
          aria-label="Alignment"
          @value={{this.align}}
          @deselectable={{false}}
          @onValueChange={{this.setAlign}}
          class="ref-group"
          as |g|
        >
          <g.Toggle
            @value="left"
            aria-label="Align left"
            class="ref-tool"
          >{{icon AlignLeft}}</g.Toggle>
          <g.Toggle
            @value="center"
            aria-label="Align center"
            class="ref-tool"
          >{{icon AlignCenter}}</g.Toggle>
          <g.Toggle
            @value="right"
            aria-label="Align right"
            class="ref-tool"
          >{{icon AlignRight}}</g.Toggle>
        </tb.ToggleGroup>
      </Toolbar>
      <p class="ref-sample" style={{this.style}}>The quick brown fox</p>
    </div>
  </template>
}

export const tiles: Tile[] = [
  {
    id: "reference-switches",
    title: "Stay connected.",
    blurb: "Switches that slide and submit.",
    Demo: Radios,
  },
  {
    id: "reference-storage",
    title: "Know your quota.",
    blurb: "A meter, not a progress bar.",
    tone: "butter",
    Demo: Storage,
  },
  {
    id: "reference-volume",
    title: "Turn it up.",
    blurb: "Drag, click or use the arrows.",
    tone: "ink",
    Demo: Volume,
  },
  {
    id: "reference-format",
    title: "One tab stop.",
    blurb: "Two toggle groups inside a toolbar.",
    tone: "paper",
    Demo: Formatting,
  },
]
