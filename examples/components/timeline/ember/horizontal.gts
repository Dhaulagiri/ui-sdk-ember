import { Timeline } from "ember-ui-sdk/timeline"

const milestones = [
  { title: "Kickoff", dateTime: "2026-01", time: "January" },
  { title: "Design review", dateTime: "2026-03", time: "March" },
  { title: "Beta", dateTime: "2026-06", time: "June" },
  { title: "Launch", dateTime: "2026-09", time: "September" },
]

<template>
  <Timeline
    @orientation="horizontal"
    @loop={{false}}
    aria-label="Roadmap"
    as |t|
  >
    {{#each milestones key="title" as |milestone|}}
      <t.Item as |item|>
        <item.Marker />
        <item.Connector />
        <item.Title>{{milestone.title}}</item.Title>
        <item.Time datetime={{milestone.dateTime}}>
          {{milestone.time}}
        </item.Time>
      </t.Item>
    {{/each}}
  </Timeline>
</template>
