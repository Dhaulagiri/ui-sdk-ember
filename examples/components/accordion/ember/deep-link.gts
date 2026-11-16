import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <div>
    <nav data-slot="controls" aria-label="Jump to">
      <a href="#refund-timeline">Jump to the refund timeline</a>
      <a href="#return-label">Print a return label</a>
    </nav>
    <Accordion @hiddenUntilFound={{true}} as |a|>
      <a.Item @value="returns" as |i|>
        <i.Header>
          <i.Trigger>
            Returns
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>
          <div data-slot="stack">
            <p>
              Return any unused item in its original packaging within 30 days.
            </p>
            <p id="return-label">
              To print a return label, open the order and choose Return. The
              label is free.
            </p>
          </div>
        </i.Panel>
      </a.Item>
      <a.Item @value="refunds" as |i|>
        <i.Header>
          <i.Trigger>
            Refunds
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>
          <div data-slot="stack">
            <p>Refunds go back to the card you paid with.</p>
            <p id="refund-timeline">
              Timeline: we inspect the item within 2 days of receiving it, and
              your bank shows the refund 5 to 7 business days later.
            </p>
          </div>
        </i.Panel>
      </a.Item>
      <a.Item @value="exchanges" as |i|>
        <i.Header>
          <i.Trigger>
            Exchanges
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>
          <div data-slot="stack">
            <p>
              Start a return, choose Exchange and pick the new size. Shipping
              both ways is free.
            </p>
          </div>
        </i.Panel>
      </a.Item>
    </Accordion>
  </div>
</template>
