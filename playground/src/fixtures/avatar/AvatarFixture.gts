import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ChangeDetails } from "@ui-sdk/core"
import { Avatar } from "ember-ui-sdk/avatar"
import { avatarAction, avatarFixture } from "tests/fixtures/avatar.ts"

const [first, ...rest] = avatarFixture.items

export default class AvatarFixture extends Component {
  first = first
  rest = rest
  @tracked action = ""
  @tracked src: string | undefined = first.src
  @tracked mounts = 0

  get generations() {
    return [this.mounts]
  }

  onStatus = (status: string, details: ChangeDetails) => {
    this.action = avatarAction(status, details.reason)
  }
  changeImage = () => (this.src = avatarFixture.nextSrc)
  removeImage = () => (this.src = undefined)
  remount = () => this.mounts++

  <template>
    <div class="fixture">
      <button>Before</button>
      {{#each this.generations key="@identity"}}
        <Avatar class="avatar" @onLoadingStatusChange={{this.onStatus}} as |a|>
          {{#if this.src}}
            <a.Image
              class="avatar-image"
              src={{this.src}}
              alt={{this.first.name}}
            />
          {{/if}}
          <a.Fallback
            class="avatar-fallback"
          >{{this.first.initials}}</a.Fallback>
        </Avatar>
      {{/each}}
      {{#each this.rest key="name" as |item|}}
        <Avatar class="avatar" as |a|>
          {{#if item.src}}
            <a.Image
              class="avatar-image"
              src={{item.src}}
              alt={{item.name}}
              referrerpolicy={{item.referrerPolicy}}
              crossorigin={{item.crossOrigin}}
            />
          {{/if}}
          <a.Fallback
            class="avatar-fallback"
            @delay={{item.delay}}
          >{{item.initials}}</a.Fallback>
        </Avatar>
      {{/each}}
      <button {{on "click" this.changeImage}}>Change image</button>
      <button {{on "click" this.removeImage}}>Remove image</button>
      <button {{on "click" this.remount}}>Remount</button>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
