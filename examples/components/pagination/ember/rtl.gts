import Component from "@glimmer/component"
import { Pagination } from "ember-ui-sdk/pagination"
import { ChevronLeft, ChevronRight, Ellipsis } from "lucide"
import { icon } from "../../../shared/ember/icon"

export default class Rtl extends Component {
  isNumber = (item: number | string) => typeof item === "number"

  <template>
    <div dir="rtl">
      <Pagination aria-label="ترقيم الصفحات" @pageCount={{10}} as |p|>
        <p.List as |l|>
          <p.Item>
            <p.Previous data-variant="ghost">
              {{icon ChevronLeft}}
              <span data-slot="visually-hidden">السابق</span>
            </p.Previous>
          </p.Item>
          {{#each l.state.items key="@identity" as |item|}}
            <p.Item>
              {{#if (this.isNumber item)}}
                <p.Link data-variant="ghost" @page={{item}} />
              {{else}}
                <p.Ellipsis>{{icon Ellipsis}}</p.Ellipsis>
              {{/if}}
            </p.Item>
          {{/each}}
          <p.Item>
            <p.Next data-variant="ghost">
              <span data-slot="visually-hidden">التالي</span>
              {{icon ChevronRight}}
            </p.Next>
          </p.Item>
        </p.List>
      </Pagination>
    </div>
  </template>
}
