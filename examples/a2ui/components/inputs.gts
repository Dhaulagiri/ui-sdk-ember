import { guidFor } from "@ember/object/internals"
import Component from "@glimmer/component"
import type { EmberComponentSignature } from "ember-a2ui"
import { Checkbox, CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Combobox } from "ember-ui-sdk/combobox"
import { DateInput } from "ember-ui-sdk/date-input"
import { DatePicker } from "ember-ui-sdk/date-picker"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { NumberInput } from "ember-ui-sdk/number-input"
import { PasswordInput } from "ember-ui-sdk/password-input"
import { RadioGroup } from "ember-ui-sdk/radio"
import { Select } from "ember-ui-sdk/select"
import { Slider } from "ember-ui-sdk/slider"
import { Textarea } from "ember-ui-sdk/textarea"
import { TimeInput } from "ember-ui-sdk/time-input"
import {
  Calendar,
  Check,
  ChevronDown,
  ChevronLeft,
  ChevronRight,
  Eye,
  EyeOff,
  Minus,
  Plus,
} from "lucide"
import { icon } from "../../sink/icon.ts"

/*
 * The basic catalog's input components, drawn with ember-ui-sdk. Each takes the
 * same props as the basic catalog's own, so an agent's messages don't change:
 * a bound `value` arrives with `setValue`, which writes the data model.
 */

type Option = { label: string; value: string }

const first = (values: string[] | undefined) => values?.[0] ?? null

/* ChoicePicker: radios for a few options, a select for many, a combobox to filter, checkboxes for several */

type ChoicePickerProps = {
  label?: string
  variant?: "multipleSelection" | "mutuallyExclusive"
  options: Option[]
  value: string[]
  setValue: (value: string[]) => void
  filterable?: boolean
}

/** How many options a radio group shows before a select takes over. */
const RADIO_LIMIT = 4

export class ChoicePicker extends Component<
  EmberComponentSignature<ChoicePickerProps>
> {
  labelId = `${guidFor(this)}-label`

  get options() {
    return this.args.props.options ?? []
  }

  get multiple() {
    return this.args.props.variant === "multipleSelection"
  }

  get filterable() {
    return !this.multiple && Boolean(this.args.props.filterable)
  }

  get radios() {
    return (
      !this.multiple && !this.filterable && this.options.length <= RADIO_LIMIT
    )
  }

  get one() {
    return first(this.args.props.value)
  }

  get several() {
    return this.args.props.value ?? []
  }

  setOne = (value: string | null) =>
    this.args.props.setValue(value === null ? [] : [value])

  setSeveral = (values: string[]) => this.args.props.setValue(values)

  <template>
    {{#if this.multiple}}
      <div class="a2-field">
        <span class="a2-label" id={{this.labelId}}>{{@props.label}}</span>
        <CheckboxGroup
          class="a2-choices"
          aria-labelledby={{this.labelId}}
          @value={{this.several}}
          @onValueChange={{this.setSeveral}}
          as |g|
        >
          {{#each this.options key="value" as |option|}}
            <label class="a2-choice" data-slot="label">
              <g.Checkbox @value={{option.value}} class="a2-box" as |c|>
                {{~#if true~}}
                  <c.Indicator class="a2-box-mark">{{icon
                      Check
                      12
                    }}</c.Indicator>
                {{~/if~}}
              </g.Checkbox>
              {{option.label}}
            </label>
          {{/each}}
        </CheckboxGroup>
      </div>
    {{else if this.filterable}}
      <div class="a2-field">
        <Combobox
          @items={{this.options}}
          @value={{this.one}}
          @onValueChange={{this.setOne}}
          as |c|
        >
          <c.Label class="a2-label">{{@props.label}}</c.Label>
          <div class="a2-control-row">
            <c.Input class="a2-input" />
            <c.Trigger class="a2-icon-btn" aria-label="Show options">{{icon
                ChevronDown
                14
              }}</c.Trigger>
          </div>
          <c.Content class="a2-pop">
            <c.Empty class="a2-empty">No matches.</c.Empty>
            <c.List>
              {{#each this.options key="value" as |option|}}
                <c.Item
                  class="a2-item"
                  @value={{option.value}}
                  @label={{option.label}}
                  as |item|
                >
                  {{option.label}}
                  <item.Indicator>{{icon Check 14}}</item.Indicator>
                </c.Item>
              {{/each}}
            </c.List>
          </c.Content>
        </Combobox>
      </div>
    {{else if this.radios}}
      <Field class="a2-field" as |f|>
        <f.Label class="a2-label">{{@props.label}}</f.Label>
        <RadioGroup
          class="a2-choices"
          @value={{this.one}}
          @onValueChange={{this.setOne}}
          @field={{f.field}}
          as |g|
        >
          {{#each this.options key="value" as |option|}}
            <label class="a2-choice" data-slot="label">
              {{! Unchecked, a radio must be :empty to draw as a dot, not a card. }}
              <g.Radio @value={{option.value}} class="a2-radio" as |r|>
                {{~#if true~}}
                  <r.Indicator class="a2-radio-dot" />
                {{~/if~}}
              </g.Radio>
              {{option.label}}
            </label>
          {{/each}}
        </RadioGroup>
      </Field>
    {{else}}
      <Field class="a2-field" as |f|>
        <f.Label class="a2-label">{{@props.label}}</f.Label>
        <Select
          @items={{this.options}}
          @value={{this.one}}
          @onValueChange={{this.setOne}}
          @placeholder="Choose"
          as |s|
        >
          <s.Trigger class="a2-input a2-trigger" @field={{f.field}}>
            <s.Value />
            {{icon ChevronDown 14}}
          </s.Trigger>
          <s.Content class="a2-pop">
            {{#each this.options key="value" as |option|}}
              <s.Item class="a2-item" @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check 14}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </Field>
    {{/if}}
  </template>
}

/* Slider */

type SliderProps = {
  label?: string
  min?: number
  max: number
  value: number
  setValue: (value: number) => void
  steps?: number
}

export class A2Slider extends Component<EmberComponentSignature<SliderProps>> {
  get min() {
    return this.args.props.min ?? 0
  }

  // `steps` divides the range; ui-sdk's slider takes the size of one step.
  get step() {
    const { steps, max } = this.args.props
    return steps ? (max - this.min) / steps : 1
  }

  setValue = (value: number | number[]) =>
    this.args.props.setValue(Array.isArray(value) ? value[0]! : value)

  <template>
    <Field class="a2-field" as |f|>
      <Slider
        @value={{@props.value}}
        @onValueChange={{this.setValue}}
        @min={{this.min}}
        @max={{@props.max}}
        @step={{this.step}}
        @field={{f.field}}
        as |s|
      >
        <div class="a2-slider-head">
          <f.Label class="a2-label">{{@props.label}}</f.Label>
          <s.Value class="a2-slider-value" />
        </div>
        <s.Control class="a2-slider">
          <s.Track class="a2-slider-track">
            <s.Indicator class="a2-slider-fill" />
            <s.Thumb class="a2-slider-thumb" />
          </s.Track>
        </s.Control>
      </Slider>
    </Field>
  </template>
}

/* CheckBox */

type CheckBoxProps = {
  label: string
  value: boolean
  setValue: (value: boolean) => void
}

export class A2CheckBox extends Component<
  EmberComponentSignature<CheckBoxProps>
> {
  setChecked = (checked: boolean | "indeterminate") =>
    this.args.props.setValue(checked === true)

  <template>
    <label class="a2-choice" data-slot="label">
      <Checkbox
        class="a2-box"
        @checked={{@props.value}}
        @onCheckedChange={{this.setChecked}}
        as |c|
      >
        {{~#if true~}}
          <c.Indicator class="a2-box-mark">{{icon Check 12}}</c.Indicator>
        {{~/if~}}
      </Checkbox>
      {{@props.label}}
    </label>
  </template>
}

/* TextField: an input, a textarea, a number input or a password input, by variant */

type TextFieldProps = {
  label: string
  value?: string
  setValue: (value: string) => void
  placeholder?: string
  variant?: "longText" | "number" | "shortText" | "obscured"
}

export class TextField extends Component<
  EmberComponentSignature<TextFieldProps>
> {
  get variant() {
    return this.args.props.variant ?? "shortText"
  }

  get long() {
    return this.variant === "longText"
  }

  get number() {
    return this.variant === "number"
  }

  get obscured() {
    return this.variant === "obscured"
  }

  get numberValue() {
    const value = Number.parseFloat(this.args.props.value ?? "")
    return Number.isNaN(value) ? null : value
  }

  setText = (value: string) => this.args.props.setValue(value)

  setNumber = (value: number | null) =>
    this.args.props.setValue(value === null ? "" : String(value))

  <template>
    <Field class="a2-field" as |f|>
      <f.Label class="a2-label">{{@props.label}}</f.Label>
      {{#if this.long}}
        <Textarea
          class="a2-input a2-textarea"
          placeholder={{@props.placeholder}}
          @value={{@props.value}}
          @onValueChange={{this.setText}}
          @field={{f.field}}
        />
      {{else if this.number}}
        <NumberInput
          @value={{this.numberValue}}
          @onValueChange={{this.setNumber}}
          @field={{f.field}}
          as |n|
        >
          <n.Group class="a2-number">
            <n.Decrement class="a2-icon-btn" aria-label="Decrease">{{icon
                Minus
                14
              }}</n.Decrement>
            <n.Control class="a2-input" placeholder={{@props.placeholder}} />
            <n.Increment class="a2-icon-btn" aria-label="Increase">{{icon
                Plus
                14
              }}</n.Increment>
          </n.Group>
        </NumberInput>
      {{else if this.obscured}}
        <PasswordInput
          class="a2-control-row"
          @value={{@props.value}}
          @onValueChange={{this.setText}}
          as |p|
        >
          <p.Control
            class="a2-input"
            placeholder={{@props.placeholder}}
            @field={{f.field}}
          />
          <p.Toggle class="a2-icon-btn" aria-label="Show password" as |t|>
            {{#if t.state.visible}}
              {{icon EyeOff 14}}
            {{else}}
              {{icon Eye 14}}
            {{/if}}
          </p.Toggle>
        </PasswordInput>
      {{else}}
        <Input
          class="a2-input"
          placeholder={{@props.placeholder}}
          @value={{@props.value}}
          @onValueChange={{this.setText}}
          @field={{f.field}}
        />
      {{/if}}
    </Field>
  </template>
}

/* DateTimeInput: a date picker, a time input, or both in one date input */

type DateTimeInputProps = {
  label?: string
  value: string
  setValue: (value: string) => void
  enableDate?: boolean
  enableTime?: boolean
  min?: string
  max?: string
}

const datePart = (value: string | undefined) => value?.slice(0, 10) || null
const timePart = (value: string | undefined) =>
  value?.match(/\d{2}:\d{2}/)?.[0] ?? null
const dateTimePart = (value: string | undefined) =>
  value?.match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}/)?.[0] ?? null

export class DateTimeInput extends Component<
  EmberComponentSignature<DateTimeInputProps>
> {
  // With neither flag set, the basic catalog shows a date.
  get both() {
    return Boolean(this.args.props.enableDate && this.args.props.enableTime)
  }

  get timeOnly() {
    return Boolean(this.args.props.enableTime && !this.args.props.enableDate)
  }

  get date() {
    return datePart(this.args.props.value)
  }

  get time() {
    return timePart(this.args.props.value)
  }

  get dateTime() {
    return dateTimePart(this.args.props.value)
  }

  get minDate() {
    return datePart(this.args.props.min) ?? undefined
  }

  get maxDate() {
    return datePart(this.args.props.max) ?? undefined
  }

  get minTime() {
    return timePart(this.args.props.min) ?? undefined
  }

  get maxTime() {
    return timePart(this.args.props.max) ?? undefined
  }

  set = (value: string | null) => this.args.props.setValue(value ?? "")

  // A single date picker only reports one date, never a range.
  setDate = (value: string | [string, string] | null) =>
    this.set(Array.isArray(value) ? value[0] : value)

  <template>
    {{#if this.both}}
      <Field class="a2-field" as |f|>
        <f.Label class="a2-label">{{@props.label}}</f.Label>
        <DateInput
          class="a2-input a2-segments"
          @granularity="minute"
          @value={{this.dateTime}}
          @onValueChange={{this.set}}
          @field={{f.field}}
        />
      </Field>
    {{else if this.timeOnly}}
      <Field class="a2-field" as |f|>
        <f.Label class="a2-label">{{@props.label}}</f.Label>
        <TimeInput
          class="a2-input a2-segments"
          @value={{this.time}}
          @onValueChange={{this.set}}
          @min={{this.minTime}}
          @max={{this.maxTime}}
          @field={{f.field}}
        />
      </Field>
    {{else}}
      <Field class="a2-field" as |f|>
        <f.Label class="a2-label">{{@props.label}}</f.Label>
        <DatePicker
          @value={{this.date}}
          @onValueChange={{this.setDate}}
          @min={{this.minDate}}
          @max={{this.maxDate}}
          as |dp|
        >
          <div class="a2-control-row">
            <dp.Input class="a2-input a2-segments" @field={{f.field}} />
            <dp.Trigger class="a2-icon-btn" aria-label="Open calendar">{{icon
                Calendar
                14
              }}</dp.Trigger>
          </div>
          <dp.Content class="a2-pop a2-calendar">
            <div class="a2-calendar-head">
              <dp.Previous class="a2-icon-btn">{{icon
                  ChevronLeft
                  14
                }}</dp.Previous>
              <dp.Heading class="a2-calendar-heading" />
              <dp.Next class="a2-icon-btn">{{icon ChevronRight 14}}</dp.Next>
            </div>
            <dp.Grid class="a2-calendar-grid" />
          </dp.Content>
        </DatePicker>
      </Field>
    {{/if}}
  </template>
}
