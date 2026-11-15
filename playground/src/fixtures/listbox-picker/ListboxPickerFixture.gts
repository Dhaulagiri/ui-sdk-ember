import type { ModifierLike } from "@glint/template"
import { capabilities, setModifierManager } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { bindScrollPicker } from "@ui-sdk/core"
import { Listbox } from "ember-ui-sdk/listbox"
import {
  pickerFixtures,
  type PickerFixture,
} from "tests/fixtures/listbox-picker.ts"

class Picker {
  @tracked value: string | null
  @tracked changes: string[] = []

  constructor(public fixture: PickerFixture) {
    this.value = fixture.defaultValue
  }

  choose = (next: string | null) => {
    this.value = next
    this.changes = [...this.changes, String(next)]
  }

  get joined() {
    return this.changes.join(",")
  }

  get statusLabel() {
    return `${this.fixture.label} changes`
  }
}

type State = { cleanup: () => void; gone: boolean }

const scrollPicker = setModifierManager(
  () => ({
    capabilities: capabilities("3.22"),
    createModifier: () => ({ cleanup: () => {}, gone: false }),
    installModifier: (
      state: State,
      el: Element,
      { positional: [picker] }: { positional: [Picker] }
    ) =>
      // The options bind after the list, so the picker measures them once they have.
      queueMicrotask(() => {
        if (!state.gone) {
          state.cleanup = bindScrollPicker(el as HTMLElement, {
            onSelect: (item) => picker.choose(picker.fixture.items[item].value),
          })
        }
      }),
    updateModifier: () => {},
    destroyModifier: (state: State) => {
      state.gone = true
      state.cleanup()
    },
  }),
  function () {} as unknown as ModifierLike<{
    Element: Element
    Args: { Positional: [Picker] }
  }>
)

export default class ListboxPickerFixture extends Component {
  pickers = pickerFixtures.map((fixture) => new Picker(fixture))
  scrollPicker = scrollPicker

  <template>
    <div class="fixture">
      <button>Before</button>
      {{#each this.pickers as |picker|}}
        <Listbox
          class="picker"
          aria-label={{picker.fixture.label}}
          @orientation={{picker.fixture.orientation}}
          @keepInView={{false}}
          @value={{picker.value}}
          @onValueChange={{picker.choose}}
          {{this.scrollPicker picker}}
          as |l|
        >
          {{#each picker.fixture.items key="value" as |item|}}
            <l.Item
              class="picker-item"
              @value={{item.value}}
              @disabled={{item.disabled}}
            >
              {{item.value}}
            </l.Item>
          {{/each}}
        </Listbox>
        <output
          role="status"
          aria-label={{picker.statusLabel}}
        >{{picker.joined}}</output>
      {{/each}}
      <button>After</button>
    </div>
  </template>
}
