import { Collapsible } from "ember-ui-sdk/collapsible"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const items = [
  { name: "Linen shirt", price: "$48.00" },
  { name: "Canvas tote", price: "$18.00" },
  { name: "Wool socks", price: "$18.00" },
]

<template>
  <Collapsible data-variant="card" as |c|>
    <c.Trigger>
      <span data-slot="stack">
        <span>Order #4189</span>
        <span data-slot="hint">3 items, $84.00</span>
      </span>
      {{icon ChevronDown}}
    </c.Trigger>
    <c.Panel>
      {{#each items key="name" as |item|}}
        <div data-slot="row">
          <span>{{item.name}}</span>
          <span>{{item.price}}</span>
        </div>
      {{/each}}
    </c.Panel>
  </Collapsible>
</template>
