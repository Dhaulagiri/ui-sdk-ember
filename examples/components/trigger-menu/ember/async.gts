import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"

const channels = [
  "announcements",
  "design",
  "design-reviews",
  "engineering",
  "general",
  "launches",
  "support",
]

function searchChannels(query: string, { signal }: { signal: AbortSignal }) {
  return new Promise<{ value: string; label: string }[]>((resolve, reject) => {
    const timer = setTimeout(
      () =>
        resolve(
          channels
            .filter((channel) => channel.includes(query.toLowerCase()))
            .map((channel) => ({ value: channel, label: channel }))
        ),
      600
    )
    signal.addEventListener("abort", () => {
      clearTimeout(timer)
      reject(signal.reason)
    })
  })
}

export default class Async extends Component {
  triggers = [{ char: "#", type: "channel", items: searchChannels }]

  statusText = (state: { loading: boolean; count: number }) =>
    state.loading
      ? "Loading channels…"
      : state.count
        ? `${state.count} ${state.count === 1 ? "channel" : "channels"}`
        : ""

  <template>
    <TriggerMenu @triggers={{this.triggers}} as |m|>
      <Field as |f|>
        <f.Label>Message</f.Label>
        <f.Control @render={{true}} as |control|>
          <m.Input @render={{true}} as |input|>
            <textarea
              {{input.part}}
              {{control.part}}
              placeholder="Type # to link a channel…"
            ></textarea>
          </m.Input>
        </f.Control>
      </Field>
      <m.Content>
        <m.Status as |s|>{{this.statusText s.state}}</m.Status>
        <m.Empty as |e|>
          {{#unless e.state.loading}}No channels match “{{e.state.query}}”{{/unless}}
        </m.Empty>
        <m.List as |list|>
          {{#each list.state.items key="value" as |item|}}
            <m.Item @value={{item.value}} @label={{item.label}}>
              {{item.label}}
            </m.Item>
          {{/each}}
        </m.List>
      </m.Content>
    </TriggerMenu>
  </template>
}
