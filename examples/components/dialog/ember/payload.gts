import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import {
  createDialogController,
  Dialog,
  DialogTrigger,
} from "ember-ui-sdk/dialog"
import { useLog } from "../../../shared/ember/log"

type Invoice = {
  id: string
  customer: string
  amount: string
  status: "Paid" | "Due"
}

const invoices: Invoice[] = [
  { id: "INV-001", customer: "Acme", amount: "$250.00", status: "Paid" },
  { id: "INV-002", customer: "Globex", amount: "$150.00", status: "Due" },
  { id: "INV-003", customer: "Initech", amount: "$350.00", status: "Due" },
]

const isPaid = (invoice: Invoice) => invoice.status === "Paid"

export default class Payload extends Component {
  log = useLog(this)
  invoices = invoices
  isPaid = isPaid
  reminder = createDialogController<Invoice, "send">()

  remindFromCode = async () => {
    const { reason, returnValue } = await this.reminder.open({
      payload: invoices[2],
    })
    this.log(
      returnValue === "send" ? "Reminder sent from code" : `Closed (${reason})`
    )
  }

  onOpenChange = (open: boolean, details: { returnValue?: string }) => {
    if (!open && details.returnValue === "send") {
      this.log("Reminder sent")
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.remindFromCode}}>Open from Code</button>
      </div>
      <ul data-slot="list">
        {{#each this.invoices key="id" as |invoice|}}
          <li data-slot="row">
            {{invoice.customer}}
            <span data-slot="hint">{{invoice.amount}}
              ·
              {{invoice.status}}</span>
            <DialogTrigger
              @controller={{this.reminder}}
              @payload={{invoice}}
              @disabled={{this.isPaid invoice}}
              aria-label="Remind {{invoice.customer}}"
            >
              Remind
            </DialogTrigger>
          </li>
        {{/each}}
      </ul>
      <Dialog
        @controller={{this.reminder}}
        @onOpenChange={{this.onOpenChange}}
        as |d|
      >
        <d.Backdrop />
        <d.Content as |content|>
          <div data-slot="stack">
            <d.Title>Remind {{content.state.payload.customer}}</d.Title>
            <d.Description>
              {{content.state.payload.id}}
              for
              {{content.state.payload.amount}}
              is due. We'll email the billing contact.
            </d.Description>
          </div>
          <div data-slot="row">
            <d.Close>Cancel</d.Close>
            <d.Close data-variant="solid" @value="send">Send reminder</d.Close>
          </div>
        </d.Content>
      </Dialog>
    </div>
  </template>
}
