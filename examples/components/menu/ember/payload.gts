import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Ellipsis } from "lucide"
import { Menu, MenuTrigger, createMenuController } from "ember-ui-sdk/menu"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

type File = { name: string; size: string }

const files: File[] = [
  { name: "Roadmap.pdf", size: "2.4 MB" },
  { name: "Budget.xlsx", size: "860 KB" },
  { name: "Team photo.jpg", size: "5.1 MB" },
]

export default class Payload extends Component {
  log = useLog(this)
  files = files
  menu = createMenuController<File>()

  openFirst = async (event: MouseEvent) => {
    const result = await this.menu.open({
      payload: files[0],
      anchor: event.currentTarget as HTMLElement,
    })
    this.log(`Closed with ${result.reason}`)
  }

  onAction = (action: string) => {
    this.log(`${action} ${this.menu.getPayload()?.name}`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.openFirst}}>Open Roadmap.pdf
          Actions</button>
      </div>
      <ul data-slot="list">
        {{#each this.files key="name" as |file|}}
          <li data-slot="row">
            {{file.name}}
            <span data-slot="hint">{{file.size}}</span>
            <MenuTrigger
              @controller={{this.menu}}
              @payload={{file}}
              aria-label="Actions for {{file.name}}"
              data-variant="ghost"
              data-size="sm"
            >
              {{icon Ellipsis}}
            </MenuTrigger>
          </li>
        {{/each}}
      </ul>
      <Menu @controller={{this.menu}} @onAction={{this.onAction}} as |m|>
        <m.Content @align="end" as |content|>
          <m.Group as |g|>
            <g.Label>{{content.state.payload.name}}</g.Label>
            <m.Item @value="open">Open</m.Item>
            <m.Item @value="rename">Rename</m.Item>
            <m.Item @value="duplicate">Duplicate</m.Item>
          </m.Group>
          <m.Separator />
          <m.Item @value="delete">Delete</m.Item>
        </m.Content>
      </Menu>
    </div>
  </template>
}
