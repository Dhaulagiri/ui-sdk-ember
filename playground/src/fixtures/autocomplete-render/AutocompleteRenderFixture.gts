import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { autocompleteFixture as f } from "tests/fixtures/autocomplete.ts"

const items = f.items.slice(0, 3)

<template>
  <div class="fixture">
    <button>Before</button>
    <Autocomplete @name={{f.name}} as |c|>
      <c.Label class="label">{{f.label}}</c.Label>
      <c.Input @render={{true}} as |field|>
        <input
          class="input {{if field.state.open 'is-open' 'is-closed'}}"
          {{field.part}}
        />
      </c.Input>
      <c.Trigger aria-label={{f.trigger}}>▾</c.Trigger>
      <c.Content class="popup list-popup">
        <c.List>
          <c.Item @value="docs" @label="Docs" @render={{true}} as |item|>
            <a class="item" href="#docs" {{item.part}}>Docs</a>
          </c.Item>
          {{#each items key="value" as |entry|}}
            <c.Item
              class="item"
              @value={{entry.value}}
              @label={{entry.label}}
              as |item|
            >
              {{~entry.label}}{{if item.state.highlighted " ←"~}}
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Autocomplete>
    <button>After</button>
  </div>
</template>
