import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"

export default class Rtl extends Component {
  toast = createToaster()

  showToast = () => {
    this.toast("تم إنشاء الحدث", {
      description: "الأحد 3 ديسمبر الساعة 9:00 صباحًا",
    })
  }

  <template>
    <div dir="rtl">
      <button type="button" {{on "click" this.showToast}}>
        إظهار الإشعار
      </button>
      <ToastRegion @toaster={{this.toast}} as |toast item t|>
        <t.Toast>
          <div data-slot="stack">
            <t.Title />
            <t.Description />
          </div>
        </t.Toast>
      </ToastRegion>
    </div>
  </template>
}
