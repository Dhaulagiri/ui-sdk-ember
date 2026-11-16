import { Collapsible } from "ember-ui-sdk/collapsible"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Collapsible data-variant="card" as |c|>
    <c.Trigger>
      <span data-slot="stack">
        <span>Ingredients</span>
        <span data-slot="hint">Morning buns, makes 12</span>
      </span>
      {{icon ChevronDown}}
    </c.Trigger>
    <c.Panel @hiddenUntilFound={{true}}>
      <p>Flour, butter, brown sugar, eggs, a pinch of cardamom and sea salt.</p>
    </c.Panel>
  </Collapsible>
</template>
