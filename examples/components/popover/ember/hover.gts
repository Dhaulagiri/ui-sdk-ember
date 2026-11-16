import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { Popover } from "ember-ui-sdk/popover"
import { useLog } from "../../../shared/ember/log"

export default class Hover extends Component {
  log = useLog(this)

  follow = () => this.log("Followed @kofi")

  <template>
    <Popover @openOnHover={{true}} @delay={{200}} @closeDelay={{150}} as |p|>
      <p.Trigger>@kofi</p.Trigger>
      <p.Content @sideOffset={{8}}>
        <p.Arrow />
        <p.Title>Kofi Mensah</p.Title>
        <p.Description>Engineering manager, platform team.</p.Description>
        <div data-slot="row">
          <button
            type="button"
            data-size="sm"
            data-variant="solid"
            {{on "click" this.follow}}
          >
            Follow
          </button>
        </div>
      </p.Content>
    </Popover>
  </template>
}
