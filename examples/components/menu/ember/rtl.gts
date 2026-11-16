import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronRight, File, Folder, Link, Mail, Share, Trash } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "../../../shared/ember/icon"

export default class Rtl extends Component {
  @tracked action = ""

  onAction = (value: string) => {
    this.action = value
  }

  get output() {
    return this.action ? `نُفّذ: ${this.action}` : "اختر عنصرًا"
  }

  <template>
    <div dir="rtl" data-slot="stack">
      <Menu @onAction={{this.onAction}} as |m|>
        <m.Trigger>ملف</m.Trigger>
        <m.Content>
          <m.Item @value="new" @shortcut="mod+n">
            {{icon File}}
            جديد
          </m.Item>
          <m.Item @value="open" @shortcut="mod+o">
            {{icon Folder}}
            فتح…
          </m.Item>
          <m.Separator />
          <m.Sub as |s|>
            <s.Trigger>
              {{icon Share}}
              مشاركة
              {{icon ChevronRight}}
            </s.Trigger>
            <s.Content>
              <s.Item @value="email">
                {{icon Mail}}
                البريد الإلكتروني
              </s.Item>
              <s.Item @value="copy-link">
                {{icon Link}}
                نسخ الرابط
              </s.Item>
            </s.Content>
          </m.Sub>
          <m.Separator />
          <m.Item @value="delete">
            {{icon Trash}}
            حذف
          </m.Item>
        </m.Content>
      </Menu>
      <output data-slot="output">{{this.output}}</output>
    </div>
  </template>
}
