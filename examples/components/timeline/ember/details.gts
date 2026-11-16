import { ChevronDown } from "lucide"
import { Collapsible } from "ember-ui-sdk/collapsible"
import { Timeline } from "ember-ui-sdk/timeline"
import { icon } from "../../../shared/ember/icon"

const releases = [
  {
    title: "Version 2.4",
    dateTime: "2026-10-28",
    time: "October 28",
    description: "Faster search and resumable uploads.",
    changes: [
      "Search now matches file contents, not only names.",
      "Uploads resume after the connection drops.",
    ],
  },
  {
    title: "Version 2.3",
    dateTime: "2026-09-30",
    time: "September 30",
    description: "Shared links and a new sidebar.",
    changes: [
      "Shared links remember the folder they were opened from.",
      "The sidebar collapses to icons on narrow screens.",
    ],
  },
  {
    title: "Version 2.2",
    dateTime: "2026-08-26",
    time: "August 26",
    description: "Dark mode follows your system.",
    changes: ["Dark mode follows the system setting.", "Avatars are sharper."],
  },
]

<template>
  <Timeline aria-label="Changelog" as |t|>
    {{#each releases key="title" as |release|}}
      <t.Item as |item|>
        <item.Marker />
        <item.Connector />
        <item.Title>{{release.title}}</item.Title>
        <item.Time datetime={{release.dateTime}}>{{release.time}}</item.Time>
        <item.Description>{{release.description}}</item.Description>
        <Collapsible as |c|>
          <c.Trigger>
            What Changed
            {{icon ChevronDown}}
          </c.Trigger>
          <c.Panel>
            <ul>
              {{#each release.changes key="@identity" as |change|}}
                <li>{{change}}</li>
              {{/each}}
            </ul>
          </c.Panel>
        </Collapsible>
      </t.Item>
    {{/each}}
  </Timeline>
</template>
