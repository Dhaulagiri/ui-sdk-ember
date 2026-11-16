import Component from "@glimmer/component"
import { Button } from "ember-ui-sdk/button"
import { useLog } from "../../../shared/ember/log"

export default class Basic extends Component {
  log = useLog(this)

  pressed = () => this.log("Pressed")

  <template>
    <Button @onClick={{this.pressed}}>Button</Button>
  </template>
}
