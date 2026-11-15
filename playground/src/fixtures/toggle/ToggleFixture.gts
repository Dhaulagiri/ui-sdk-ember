import { fn, get } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ChangeDetails } from "@ui-sdk/core"
import { Button, type ButtonActionDetails } from "ember-ui-sdk/button"
import { Separator } from "ember-ui-sdk/separator"
import {
  createToggleGroupController,
  Toggle,
  ToggleGroup,
} from "ember-ui-sdk/toggle"
import { changedValue, toggleOptions } from "tests/fixtures/page.ts"
import { toggleAction, toggleFixture } from "tests/fixtures/toggle.ts"

const gate = () => {
  let settle:
    { resolve: () => void; reject: (reason: Error) => void } | undefined
  return {
    wait: () =>
      new Promise<void>((resolve, reject) => (settle = { resolve, reject })),
    resolve: () => settle?.resolve(),
    reject: () => settle?.reject(new Error("Offline")),
  }
}

export default class ToggleFixture extends Component {
  options = toggleOptions()
  formatting = createToggleGroupController()
  fixture = toggleFixture
  saving = gate()
  publishing = gate()
  @tracked action = ""
  @tracked pressedWith = ""
  @tracked submissions = 0

  values: Record<string, string[]> = {
    alignment: this.options.alignment
      ? [this.options.alignment]
      : toggleFixture.alignment.defaultValue,
    formatting: toggleFixture.formatting.defaultValue,
  }

  groups = [
    {
      ...toggleFixture.alignment,
      multiple: false,
      disabled: false,
      controller: undefined,
      separated: false,
    },
    {
      ...toggleFixture.formatting,
      multiple: true,
      disabled: this.options.disabled,
      controller: this.formatting,
      separated: true,
    },
  ]

  onValueChange = (
    name: string,
    value: string[],
    details: { cancel: () => void }
  ) => {
    if (
      this.options.cancel &&
      changedValue(this.values[name]!, value) === this.options.cancel
    ) {
      return details.cancel()
    }
    this.values[name] = value
    this.action = toggleAction.group(name, value)
  }

  onPressedChange = (pressed: boolean, details: ChangeDetails) => {
    if (this.options.cancel === toggleFixture.toggle.value) {
      return details.cancel()
    }
    this.action = toggleAction.toggle(pressed)
  }

  save = (_event: MouseEvent, { source }: ButtonActionDetails) => {
    this.action = "save"
    this.pressedWith = source
  }

  publish = async () => {
    this.action = "publishing"
    await this.publishing.wait()
    this.action = "published"
  }

  remove = () => (this.action = "delete")
  archive = () => (this.action = "archive")
  clearFormatting = () => this.formatting.setValue([])

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submissions++
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <Toggle
        class="toggle"
        @defaultPressed={{this.options.defaultPressed}}
        @onPressedChange={{this.onPressedChange}}
      >{{this.fixture.toggle.label}}</Toggle>
      {{#each this.groups key="name" as |group|}}
        {{#if group.separated}}
          <Separator class="rule" @orientation="vertical" />
        {{/if}}
        <ToggleGroup
          class="toggle-group"
          aria-label={{group.label}}
          @defaultValue={{get this.values group.name}}
          @multiple={{group.multiple}}
          @disabled={{group.disabled}}
          @controller={{group.controller}}
          @orientation={{this.options.orientation}}
          @deselectable={{this.options.deselectable}}
          @loop={{this.options.loop}}
          @onValueChange={{fn this.onValueChange group.name}}
          as |g|
        >
          {{#each group.items key="value" as |item|}}
            <g.Toggle
              class="toggle"
              @value={{item.value}}
              @disabled={{item.disabled}}
            >{{item.label}}</g.Toggle>
          {{/each}}
        </ToggleGroup>
      {{/each}}
      <form
        aria-label={{this.fixture.form.label}}
        {{on "submit" this.onSubmit}}
      >
        <label>
          {{this.fixture.form.field}}
          <input
            name="name"
            {{! @glint-expect-error defaultValue is a property, not an attribute }}
            defaultValue={{this.fixture.form.defaultName}}
          />
        </label>
        <Button
          class="button"
          @type="submit"
          @onClick={{this.saving.wait}}
        >Submit</Button>
        <Button class="button" @type="reset">Reset</Button>
        <Button
          class="button"
          @disabled={{true}}
          @onClick={{this.remove}}
        >Delete</Button>
        <Button
          class="button"
          @type="submit"
          @disabled={{true}}
          @focusableWhenDisabled={{true}}
          @onClick={{this.archive}}
        >
          Archive
        </Button>
      </form>
      <Button class="button" @onClick={{this.save}}>Save</Button>
      <Button class="button" @onClick={{this.publish}}>Publish</Button>
      <button {{on "click" this.clearFormatting}}>Clear formatting</button>
      <button {{on "click" this.saving.resolve}}>Finish saving</button>
      <button {{on "click" this.publishing.resolve}}>Finish publishing</button>
      <button {{on "click" this.publishing.reject}}>Fail publishing</button>
      <Button class="button" @render={{true}} as |b|>
        <a
          {{b.part}}
          class="button"
          href={{this.fixture.docs.href}}
        >{{this.fixture.docs.label}}</a>
      </Button>
      <Button class="button" @disabled={{true}} @render={{true}} as |b|>
        <a
          {{b.part}}
          class="button"
          href={{this.fixture.changelog.href}}
        >{{this.fixture.changelog.label}}</a>
      </Button>
      <Separator class="rule" />
      <Separator class="rule" @decorative={{true}} />
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Submissions">{{this.submissions}}</output>
      <output aria-label="Pressed with">{{this.pressedWith}}</output>
    </div>
  </template>
}
