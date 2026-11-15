import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ScrollArea } from "ember-ui-sdk/scroll-area"
import {
  scrollAreaFixture,
  scrollAreaOptions,
} from "tests/fixtures/scroll-area.ts"

const { tags, gallery, short, chat } = scrollAreaFixture
const { native, ...options } = scrollAreaOptions()

type Message = { text: string; image?: boolean }

const imageHeight = (loaded: boolean) =>
  `display:block;height:${loaded ? `${chat.imageHeight}px` : "0px"}`
const anchor = (item: string) => `#${item}`

export default class ScrollAreaFixture extends Component {
  tags = tags
  gallery = gallery
  short = short
  chat = chat
  native = native
  options = options
  @tracked messages: Message[] = chat.messages.map((text) => ({ text }))
  @tracked imagesLoaded = false

  addMessage = (image = false) => {
    this.messages = [
      ...this.messages,
      { text: `Message ${this.messages.length + 1}`, image },
    ]
  }
  addImage = () => this.addMessage(true)
  addPlain = () => this.addMessage()
  stream = () => {
    const last = this.messages[this.messages.length - 1]!
    this.messages = [
      ...this.messages.slice(0, -1),
      { ...last, text: last.text + chat.streamed },
    ]
  }
  loadImages = () => (this.imagesLoaded = true)

  <template>
    <div class="fixture scroll-fixture">
      <button>Before</button>
      <ScrollArea
        class="scroll-area"
        @type={{this.options.type}}
        @scrollHideDelay={{this.options.scrollHideDelay}}
        as |s|
      >
        <s.Viewport
          class="scroll-area-viewport"
          role="region"
          aria-label={{this.tags.label}}
        >
          <s.Content>
            {{#each this.tags.items key="@identity" as |item|}}
              <p class="scroll-area-item">{{item}}</p>
            {{/each}}
          </s.Content>
        </s.Viewport>
        {{#unless this.native}}
          <s.Scrollbar class="scroll-area-scrollbar" as |b|>
            <b.Thumb class="scroll-area-thumb" />
          </s.Scrollbar>
        {{/unless}}
      </ScrollArea>
      <ScrollArea
        class="scroll-area is-wide"
        @type={{this.options.type}}
        @scrollHideDelay={{this.options.scrollHideDelay}}
        as |s|
      >
        <s.Viewport
          class="scroll-area-viewport"
          role="region"
          aria-label={{this.gallery.label}}
        >
          <s.Content class="scroll-area-grid">
            {{#each this.gallery.items key="@identity" as |item|}}
              <a href={{anchor item}}>{{item}}</a>
            {{/each}}
          </s.Content>
        </s.Viewport>
        <s.Scrollbar class="scroll-area-scrollbar" as |b|>
          <b.Thumb class="scroll-area-thumb" />
        </s.Scrollbar>
        <s.Scrollbar
          class="scroll-area-scrollbar"
          @orientation="horizontal"
          as |b|
        >
          <b.Thumb class="scroll-area-thumb" />
        </s.Scrollbar>
        <s.Corner class="scroll-area-corner" />
      </ScrollArea>
      <ScrollArea
        class="scroll-area"
        @type={{this.options.type}}
        @scrollHideDelay={{this.options.scrollHideDelay}}
        as |s|
      >
        <s.Viewport
          class="scroll-area-viewport"
          role="region"
          aria-label={{this.short.label}}
        >
          <s.Content>
            {{#each this.short.items key="@identity" as |item|}}
              <p class="scroll-area-item">{{item}}</p>
            {{/each}}
          </s.Content>
        </s.Viewport>
        <s.Scrollbar class="scroll-area-scrollbar" as |b|>
          <b.Thumb class="scroll-area-thumb" />
        </s.Scrollbar>
      </ScrollArea>
      <ScrollArea
        class="scroll-area is-chat"
        @stickToEnd={{true}}
        @type={{this.options.type}}
        @scrollHideDelay={{this.options.scrollHideDelay}}
        as |s|
      >
        <s.Viewport
          class="scroll-area-viewport"
          role="region"
          aria-label={{this.chat.label}}
        >
          <s.Content>
            {{#each this.messages key="@index" as |message|}}
              <p class="scroll-area-message">
                {{message.text}}
                {{#if message.image}}
                  <span
                    role="img"
                    aria-label="Image"
                    style={{imageHeight this.imagesLoaded}}
                  ></span>
                {{/if}}
              </p>
            {{/each}}
          </s.Content>
        </s.Viewport>
        <s.Scrollbar class="scroll-area-scrollbar" as |b|>
          <b.Thumb class="scroll-area-thumb" />
        </s.Scrollbar>
        <s.ScrollToEnd
          class="scroll-area-end"
        >{{this.chat.jump}}</s.ScrollToEnd>
      </ScrollArea>
      <button {{on "click" this.addPlain}}>Add message</button>
      <button {{on "click" this.stream}}>Stream</button>
      <button {{on "click" this.addImage}}>Add image</button>
      <button {{on "click" this.loadImages}}>Load images</button>
      <button>After</button>
      <output role="status" aria-label="Last action"></output>
      <div class="scroll-fixture-spacer"></div>
    </div>
  </template>
}
