import { Collapsible } from "ember-ui-sdk/collapsible"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const updates = [
  { label: "Out for delivery", time: "07:40" },
  { label: "Arrived at the local depot", time: "05:12" },
  { label: "Left the sorting center", time: "Wed 21:03" },
]

<template>
  <Collapsible data-variant="card" as |c|>
    <c.Trigger @render={{true}} as |t|>
      <h3>
        <button {{t.part}}>
          <span data-slot="stack">
            <span>Track parcel</span>
            <span data-slot="hint">{{if
                t.state.open
                "3 updates"
                "Arrives Thursday"
              }}</span>
          </span>
          {{icon ChevronDown}}
        </button>
      </h3>
    </c.Trigger>
    <c.Panel @render={{true}} as |p|>
      <ol {{p.part}}>
        {{#each updates key="label" as |update|}}
          <li data-slot="row">
            <span>{{update.label}}</span>
            <span>{{update.time}}</span>
          </li>
        {{/each}}
      </ol>
    </c.Panel>
  </Collapsible>
</template>
