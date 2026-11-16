import { Check, SlidersHorizontal } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Popover } from "ember-ui-sdk/popover"
import { icon } from "../../../shared/ember/icon"

const types = [
  { label: "Documents", checked: true },
  { label: "Images", checked: false },
  { label: "Shared with me", checked: true },
]

<template>
  <div data-slot="row">
    <input
      id="file-search"
      type="search"
      placeholder="Search files…"
      aria-label="Search files"
    />
    <Popover as |p|>
      <p.Trigger aria-label="Search filters">{{icon
          SlidersHorizontal
        }}</p.Trigger>
      <p.Content @anchor="#file-search" @align="start" @sideOffset={{8}}>
        <p.Title>Filters</p.Title>
        <p.Description>Show only these kinds of files.</p.Description>
        <div data-slot="stack">
          {{#each types key="label" as |type|}}
            <label data-slot="label">
              <Checkbox @defaultChecked={{type.checked}} as |c|>
                <c.Indicator>{{icon Check}}</c.Indicator>
              </Checkbox>
              {{type.label}}
            </label>
          {{/each}}
        </div>
        <div data-slot="row">
          <p.Close>Cancel</p.Close>
          <p.Close data-variant="solid">Apply</p.Close>
        </div>
      </p.Content>
    </Popover>
  </div>
</template>
