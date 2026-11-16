import { array } from "@ember/helper"
import { CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Check, Minus } from "lucide"
import { icon } from "../../../shared/ember/icon"

const backups = [
  { value: "photos", label: "Photos" },
  { value: "documents", label: "Documents" },
  { value: "messages", label: "Messages" },
]

const folders = [
  { value: "desktop", label: "Desktop", disabled: true },
  { value: "projects", label: "Projects", disabled: false },
  { value: "downloads", label: "Downloads", disabled: false },
]

const folderValues = folders.map((item) => item.value)

<template>
  <div data-slot="stack">
    <div data-slot="stack">
      <h3 id="disabled-backups">Backups</h3>
      <p data-slot="hint">Managed by your organization.</p>
      <CheckboxGroup
        @defaultValue={{array "photos" "documents"}}
        @disabled={{true}}
        aria-labelledby="disabled-backups"
        as |g|
      >
        {{#each backups key="value" as |item|}}
          <label data-slot="label">
            <g.Checkbox @value={{item.value}} as |c|>
              <c.Indicator>{{icon Check}}</c.Indicator>
            </g.Checkbox>
            {{item.label}}
          </label>
        {{/each}}
      </CheckboxGroup>
    </div>
    <div data-slot="stack">
      <h3 id="disabled-folders">Sync folders</h3>
      <CheckboxGroup
        @defaultValue={{array "desktop"}}
        @allValues={{folderValues}}
        aria-labelledby="disabled-folders"
        as |g|
      >
        <label data-slot="label">
          <g.Checkbox @parent={{true}} as |c|>
            <c.Indicator>
              {{icon Check}}
              {{icon Minus}}
            </c.Indicator>
          </g.Checkbox>
          Select all
        </label>
        <div data-slot="stack">
          {{#each folders key="value" as |item|}}
            <label data-slot="label">
              <g.Checkbox
                @value={{item.value}}
                @disabled={{item.disabled}}
                as |c|
              >
                <c.Indicator>{{icon Check}}</c.Indicator>
              </g.Checkbox>
              {{item.label}}
            </label>
          {{/each}}
        </div>
      </CheckboxGroup>
    </div>
  </div>
</template>
