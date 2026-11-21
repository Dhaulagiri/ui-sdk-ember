import { htmlSafe } from "@ember/template"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  scrubTo,
  stepBy,
  stepFromKey,
  type NumberRange,
} from "@ui-sdk/core/number"
import { Slider } from "ember-ui-sdk/slider"
import "../../../vendor/ui/apps/docs/app/sink/tiles/drag.css"
import type { Tile } from "../types.ts"

/* 4. Song timeline: the playhead snaps to section starts within 1.5 s */

const SECTIONS = [
  { at: 0, label: "Intro", hue: 250 },
  { at: 9.5, label: "Verse", hue: 195 },
  { at: 24, label: "Chorus", hue: 70 },
  { at: 38.5, label: "Bridge", hue: 150 },
  { at: 52, label: "Outro", hue: 25 },
]
const SONG = 60
const songRange: NumberRange = {
  min: 0,
  max: SONG,
  step: 0.1,
  largeStep: 5,
  snap: { points: SECTIONS.map((section) => section.at), threshold: 1.5 },
}

const clock = (time: number) =>
  `${Math.floor(time / 60)}:${(time % 60).toFixed(1).padStart(4, "0")}`
const sectionAt = (time: number) =>
  SECTIONS.reduce(
    (found, section) => (section.at <= time ? section : found),
    SECTIONS[0]
  )
const percent = (time: number) => `${(time / SONG) * 100}%`

// A waveform that reads like the arrangement: quiet intro, a loud chorus, a fading outro.
const BARS = Array.from({ length: 120 }, (_, index) => {
  const time = ((index + 0.5) / 120) * SONG
  const section = sectionAt(time)
  const energy = {
    Intro: 0.32,
    Verse: 0.56,
    Chorus: 0.9,
    Bridge: 0.48,
    Outro: 0.5 - (time - 52) / 20,
  }[section.label]!
  const noise = Math.abs(Math.sin(index * 12.9898) * 43758.5453) % 1
  const pulse = 0.72 + 0.28 * Math.sin(index * 0.9)
  const height = Math.max(0.08, energy * (0.55 + 0.45 * noise) * pulse)
  return {
    x: index + 0.18,
    y: (20 - height * 19).toFixed(3),
    height: (height * 38).toFixed(3),
    style: htmlSafe(`fill: oklch(0.78 0.12 ${section.hue})`),
  }
})

const LANES = SECTIONS.map((section, index) => ({
  at: section.at,
  label: section.label,
  style: htmlSafe(
    `left: ${percent(section.at)}; width: ${percent(
      (SECTIONS[index + 1]?.at ?? SONG) - section.at
    )}; --dg-hue: ${section.hue}`
  ),
}))

const MARKS = ["0:00", "0:15", "0:30", "0:45", "1:00"]

const Waveform = <template>
  <svg
    class="dg-wave"
    viewBox="0 0 120 40"
    preserveAspectRatio="none"
    aria-hidden="true"
  >
    {{#each BARS as |bar|}}
      <rect
        x={{bar.x}}
        width="0.64"
        y={{bar.y}}
        height={{bar.height}}
        style={{bar.style}}
      ></rect>
    {{/each}}
  </svg>
</template>

class TimelineDemo extends Component {
  @tracked time = 17
  lanes = LANES
  marks = MARKS

  get section() {
    return SECTIONS.find((candidate) => candidate.at === this.time)
  }

  get current() {
    return sectionAt(this.time)
  }

  get clock() {
    return clock(this.time)
  }

  get sectionLabel() {
    return this.section ? this.section.label : `In ${this.current.label}`
  }

  get rootStyle() {
    return htmlSafe(`--dg-played: ${percent(this.time)}`)
  }

  get dotStyle() {
    return htmlSafe(`--dg-hue: ${this.current.hue}`)
  }

  isActive = (at: number) => this.section?.at === at

  format = (value: number) => {
    const on = SECTIONS.find((candidate) => candidate.at === value)
    return on ? `${clock(value)}, ${on.label}` : clock(value)
  }

  onValueChange = (next: number | number[], details: ChangeDetails<string>) => {
    const value = next as number
    const event = details.event as (KeyboardEvent & PointerEvent) | undefined
    const free = !!(event?.metaKey || event?.ctrlKey)
    const move =
      details.reason === "step-key" && event ? stepFromKey(event) : null
    if (move) {
      this.time = stepBy(this.time, move, songRange, { snap: !free })
    } else {
      this.time = scrubTo(value, songRange, { snap: !free }).value
    }
  }

  <template>
    <Slider
      class="dg-tl"
      @value={{this.time}}
      @min={{0}}
      @max={{SONG}}
      @step={{0.1}}
      @largeStep={{5}}
      @format={{this.format}}
      @onValueChange={{this.onValueChange}}
      style={{this.rootStyle}}
      as |s|
    >
      <div class="dg-tl-head">
        <p class="dg-tl-lcd" aria-hidden="true">
          <span class="dg-tl-clock">{{this.clock}}</span>
          <span class="dg-tl-total">/ 1:00.0</span>
        </p>
        <p class="dg-tl-section" data-on={{if this.section "" undefined}}>
          <span
            class="dg-tl-dot"
            style={{this.dotStyle}}
            aria-hidden="true"
          ></span>
          {{this.sectionLabel}}
        </p>
        <p class="dg-tl-meta">
          <span class="dg-tl-track">Glasshouse · demo 3</span>
          <span class="dg-tl-free">
            <kbd>⌘</kbd>
            scrubs freely
          </span>
        </p>
      </div>
      <s.Control class="dg-tl-control">
        <div class="dg-tl-art" aria-hidden="true">
          <div class="dg-tl-lanes">
            {{#each this.lanes key="at" as |lane|}}
              <span
                class="dg-tl-lane"
                data-active={{if (this.isActive lane.at) "" undefined}}
                style={{lane.style}}
              >
                {{lane.label}}
              </span>
            {{/each}}
          </div>
          <div class="dg-tl-waves">
            <Waveform />
            <div class="dg-tl-played">
              <Waveform />
            </div>
          </div>
        </div>
        <s.Track class="dg-tl-track-rail">
          <s.Indicator class="dg-tl-fill" />
          <s.Thumb aria-label="Playhead" class="dg-tl-head-thumb">
            <span class="dg-tl-cap" aria-hidden="true"></span>
          </s.Thumb>
        </s.Track>
      </s.Control>
      <div class="dg-tl-ruler" aria-hidden="true">
        {{#each this.marks as |mark|}}
          <span>{{mark}}</span>
        {{/each}}
      </div>
    </Slider>
  </template>
}

export const tiles: Tile[] = [
  {
    id: "drag-timeline",
    title: "Scrub to the chorus.",
    blurb: "The playhead snaps to each section.",
    size: "wide",
    tone: "ink",
    Demo: TimelineDemo,
  },
]
