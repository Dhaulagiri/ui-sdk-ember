import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const faq = [
  {
    value: "returns",
    question: "What is your return policy?",
    answer:
      "Return any unused item within 30 days. Once it reaches us, your refund is on its way.",
  },
  {
    value: "refunds",
    question: "How long do refunds take?",
    answer:
      "Refunds reach your card within 5 to 7 business days after we receive the item.",
  },
  {
    value: "shipping",
    question: "Do you ship internationally?",
    answer:
      "We ship to 40 countries. Duties are included in the price at checkout.",
  },
  {
    value: "tracking",
    question: "How do I track my order?",
    answer:
      "Every shipping email has a tracking link. You'll also find it under Orders.",
  },
  {
    value: "exchange",
    question: "Can I exchange an item for another size?",
    answer:
      "Yes. Start a return, choose Exchange and pick the new size. Shipping is free.",
  },
  {
    value: "gift",
    question: "Can I send an order as a gift?",
    answer:
      "Add a gift note at checkout and we'll leave the prices off the packing slip.",
  },
]

type Question = (typeof faq)[number]
type Part = { text: string; match: boolean }

function matches(question: Question, query: string) {
  const search = query.trim().toLowerCase()
  return (
    !search ||
    question.question.toLowerCase().includes(search) ||
    question.answer.toLowerCase().includes(search)
  )
}

export default class Search extends Component {
  @tracked query = ""
  @tracked value: string[] = []

  get results() {
    return faq.filter((question) => matches(question, this.query))
  }

  get empty() {
    return this.results.length === 0
  }

  highlight = (text: string, query: string) => {
    const search = query.trim().toLowerCase()
    if (!search) {
      return [{ text, match: false }]
    }
    const parts: Part[] = []
    let start = 0
    for (let index = text.toLowerCase().indexOf(search); index !== -1;) {
      if (index > start) {
        parts.push({ text: text.slice(start, index), match: false })
      }
      parts.push({
        text: text.slice(index, index + search.length),
        match: true,
      })
      start = index + search.length
      index = text.toLowerCase().indexOf(search, start)
    }
    if (start < text.length) {
      parts.push({ text: text.slice(start), match: false })
    }
    return parts
  }

  search = (next: string) => {
    this.query = next
    this.value = next.trim()
      ? this.results.map((question) => question.value)
      : []
  }

  onInput = (event: Event) =>
    this.search((event.currentTarget as HTMLInputElement).value)

  onValueChange = (next: string[]) => {
    this.value = next
  }

  <template>
    <div>
      <div data-slot="controls">
        <input
          type="search"
          aria-label="Search questions"
          placeholder="Search questions…"
          value={{this.query}}
          {{on "input" this.onInput}}
        />
      </div>
      <Accordion
        @multiple={{true}}
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        as |a|
      >
        {{#each this.results key="value" as |question|}}
          <a.Item @value={{question.value}} as |i|>
            <i.Header>
              <i.Trigger>
                <span>
                  {{#each
                    (this.highlight question.question this.query)
                    as |part|
                  }}
                    {{#if part.match}}<mark
                      >{{part.text}}</mark>{{else}}{{part.text}}{{/if}}
                  {{/each}}
                </span>
                {{icon ChevronDown}}
              </i.Trigger>
            </i.Header>
            <i.Panel>
              {{#each (this.highlight question.answer this.query) as |part|}}
                {{#if part.match}}<mark
                  >{{part.text}}</mark>{{else}}{{part.text}}{{/if}}
              {{/each}}
            </i.Panel>
          </a.Item>
        {{/each}}
      </Accordion>
      <p data-slot="hint" role="status">
        {{#if this.empty}}No questions match “{{this.query}}”.{{/if}}
      </p>
    </div>
  </template>
}
