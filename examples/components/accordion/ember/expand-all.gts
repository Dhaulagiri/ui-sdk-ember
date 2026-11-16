import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Accordion, createAccordionController } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const weeks = [
  {
    value: "week-1",
    label: "Week 1: Foundations",
    content:
      "Set up your editor, meet the command line and write your first script.",
  },
  {
    value: "week-2",
    label: "Week 2: Data and types",
    content:
      "Strings, numbers, lists and objects, and how to tell them apart when a program runs.",
  },
  {
    value: "week-3",
    label: "Week 3: Control flow",
    content:
      "Conditions, loops and functions. The project this week is a small text adventure.",
  },
  {
    value: "week-4",
    label: "Week 4: Working with files",
    content:
      "Read and write files, parse CSV and JSON, and handle the errors that come with them.",
  },
  {
    value: "week-5",
    label: "Week 5: Final project",
    content:
      "Build a tool you'll use yourself, then present it to the group in a five-minute demo.",
  },
]

export default class ExpandAll extends Component {
  syllabus = createAccordionController()
  @tracked pressed: string | null = null

  expandAll = () => this.syllabus.openAll()
  collapseAll = () => this.syllabus.closeAll()

  openChange = (value: string, open: boolean, details: { reason: string }) => {
    if (open && details.reason === "trigger-press") {
      this.pressed = value
    } else if (this.pressed === value) {
      this.pressed = null
    }
  }

  openChangeComplete = (value: string, open: boolean) => {
    if (!open || this.pressed !== value) {
      return
    }
    this.pressed = null
    document
      .getElementById(value)
      ?.scrollIntoView({ block: "nearest", behavior: "smooth" })
  }

  <template>
    <div>
      <div data-slot="controls">
        <button type="button" {{on "click" this.expandAll}}>Expand all</button>
        <button type="button" {{on "click" this.collapseAll}}>Collapse all</button>
      </div>
      <div data-slot="scroll">
        <Accordion @multiple={{true}} @controller={{this.syllabus}} as |a|>
          {{#each weeks key="value" as |week|}}
            <a.Item
              id={{week.value}}
              @value={{week.value}}
              @onOpenChange={{fn this.openChange week.value}}
              @onOpenChangeComplete={{fn this.openChangeComplete week.value}}
              as |i|
            >
              <i.Header>
                <i.Trigger>
                  {{week.label}}
                  {{icon ChevronDown}}
                </i.Trigger>
              </i.Header>
              <i.Panel>{{week.content}}</i.Panel>
            </a.Item>
          {{/each}}
        </Accordion>
      </div>
    </div>
  </template>
}
