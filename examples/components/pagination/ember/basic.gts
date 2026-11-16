import Component from "@glimmer/component"
import { Pagination } from "ember-ui-sdk/pagination"
import { ChevronLeft, ChevronRight, Ellipsis } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Basic extends Component {
  log = useLog(this)

  isNumber = (item: number | string) => typeof item === "number"

  onPageChange = (page: number, details: { reason: string }) => {
    this.log(`Page ${page} (${details.reason})`)
  }

  <template>
    <Pagination
      aria-label="Pagination"
      @pageCount={{10}}
      @onPageChange={{this.onPageChange}}
      as |p|
    >
      <p.List as |l|>
        <p.Item>
          <p.Previous data-variant="ghost">
            {{icon ChevronLeft}}
            <span data-slot="visually-hidden">Previous</span>
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
            <span data-slot="visually-hidden">Next</span>
            {{icon ChevronRight}}
          </p.Next>
        </p.Item>
      </p.List>
    </Pagination>
  </template>
}
