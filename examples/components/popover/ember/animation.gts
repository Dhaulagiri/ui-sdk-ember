import Component from "@glimmer/component"
import { Popover } from "ember-ui-sdk/popover"
import { useLog } from "../../../shared/ember/log"

export default class Animation extends Component {
  log = useLog(this)

  onOpenChange = (open: boolean) => this.log(open ? "Opening" : "Closing")

  onOpenChangeComplete = (open: boolean) => this.log(open ? "Open" : "Closed")

  <template>
    <Popover
      @onOpenChange={{this.onOpenChange}}
      @onOpenChangeComplete={{this.onOpenChangeComplete}}
      as |p|
    >
      <p.Trigger>What's New</p.Trigger>
      <p.Content @keepMounted={{true}}>
        <p.Title>What's new</p.Title>
        <p.Description>Comments now support threads and reactions.</p.Description>
        <div data-slot="row">
          <p.Close data-variant="solid">Got It</p.Close>
        </div>
      </p.Content>
    </Popover>
  </template>
}
