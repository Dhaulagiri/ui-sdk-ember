import Component from "@glimmer/component"
import { concat } from "@ember/helper"
import { Pagination } from "ember-ui-sdk/pagination"
import { ArrowLeft, ArrowRight } from "lucide"
import { icon } from "../../../shared/ember/icon"

export default class Render extends Component {
  isNumber = (item: number | string) => typeof item === "number"

  <template>
    <Pagination aria-label="Pagination" @pageCount={{10}} as |p|>
      <p.List as |l|>
        <p.Item>
          <p.Previous aria-label="Previous page" @render={{true}} as |step|>
            <button
              {{step.part}}
              title={{if
                step.state.disabled
                undefined
                (concat "Go to page " step.state.page)
              }}
            >
              {{icon ArrowLeft}}
              {{#unless step.state.disabled}}
                <span aria-hidden="true">{{step.state.page}}</span>
              {{/unless}}
            </button>
          </p.Previous>
        </p.Item>
        {{#each l.state.items key="@identity" as |item|}}
          <p.Item>
            {{#if (this.isNumber item)}}
              <p.Link @page={{item}} as |link|>
                {{#if link.state.current}}Page
                  {{link.state.page}}{{else}}{{link.state.page}}{{/if}}
              </p.Link>
            {{else}}
              <p.Ellipsis />
            {{/if}}
          </p.Item>
        {{/each}}
        <p.Item>
          <p.Next aria-label="Next page" @render={{true}} as |step|>
            <button
              {{step.part}}
              title={{if
                step.state.disabled
                undefined
                (concat "Go to page " step.state.page)
              }}
            >
              {{#unless step.state.disabled}}
                <span aria-hidden="true">{{step.state.page}}</span>
              {{/unless}}
              {{icon ArrowRight}}
            </button>
          </p.Next>
        </p.Item>
      </p.List>
    </Pagination>
  </template>
}
