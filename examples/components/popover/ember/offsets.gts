import { fn } from "@ember/helper"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Popover } from "ember-ui-sdk/popover"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const choices = [
  { name: "sideOffset", label: "Side offset", values: ["4", "8", "16", "24"] },
  { name: "alignOffset", label: "Align offset", values: ["-16", "0", "16"] },
  {
    name: "collisionPadding",
    label: "Collision padding",
    values: ["8", "24", "48"],
  },
] as const

type Name = (typeof choices)[number]["name"]

export default class Offsets extends Component {
  @tracked offsets: Record<Name, string> = {
    sideOffset: "8",
    alignOffset: "0",
    collisionPadding: "8",
  }

  valueOf = (name: Name) => this.offsets[name]

  numberOf = (name: Name) => Number(this.offsets[name])

  onValueChange = (name: Name, next: string | null) => {
    if (next) {
      this.offsets = { ...this.offsets, [name]: next }
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        {{#each choices key="name" as |choice|}}
          <Select
            @items={{choice.values}}
            @value={{this.valueOf choice.name}}
            @onValueChange={{fn this.onValueChange choice.name}}
            as |s|
          >
            <s.Label>{{choice.label}}</s.Label>
            <s.Trigger>
              <s.Value />
              {{icon ChevronDown}}
            </s.Trigger>
            <s.Content>
              {{#each choice.values key="@identity" as |value|}}
                <s.Item @value={{value}} as |item|>
                  {{value}}px
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </s.Item>
              {{/each}}
            </s.Content>
          </Select>
        {{/each}}
      </div>
      <Popover as |p|>
        <p.Trigger>Delivery</p.Trigger>
        <p.Content
          @align="start"
          @sideOffset={{this.numberOf "sideOffset"}}
          @alignOffset={{this.numberOf "alignOffset"}}
          @collisionPadding={{this.numberOf "collisionPadding"}}
        >
          <p.Title>Delivery window</p.Title>
          <p.Description>Arrives Tuesday between 9 AM and noon.</p.Description>
        </p.Content>
      </Popover>
    </div>
  </template>
}
