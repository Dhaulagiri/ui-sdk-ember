import Component from "@glimmer/component"
import {
  A2uiNode,
  type ComponentNode,
  type EmberComponentSignature,
} from "ember-a2ui"
import { Button } from "ember-ui-sdk/button"
import { Dialog } from "ember-ui-sdk/dialog"
import { Tabs } from "ember-ui-sdk/tabs"
import { X } from "lucide"
import { icon } from "../../sink/icon.ts"

/*
 * The basic catalog's Button, Tabs and Modal, drawn with ember-ui-sdk. Their
 * children are nodes, which `A2uiNode` renders with whatever catalog entry
 * they name.
 */

type ButtonProps = {
  child: ComponentNode
  variant?: "default" | "primary" | "borderless"
  action: () => void
}

export class A2Button extends Component<EmberComponentSignature<ButtonProps>> {
  get variant() {
    return this.args.props.variant ?? "default"
  }

  <template>
    <Button
      class="a2-btn"
      data-variant={{this.variant}}
      @onClick={{@props.action}}
    >
      <A2uiNode @node={{@props.child}} />
    </Button>
  </template>
}

type TabsProps = {
  tabs: { title: string; child: ComponentNode }[]
}

const indexOf = (_tab: unknown, index: number) => String(index)

export class A2Tabs extends Component<EmberComponentSignature<TabsProps>> {
  <template>
    <Tabs class="a2-tabs" @defaultValue="0" as |t|>
      <t.List class="a2-tab-list">
        {{#each @props.tabs as |tab index|}}
          <t.Tab
            class="a2-tab"
            @value={{indexOf tab index}}
          >{{tab.title}}</t.Tab>
        {{/each}}
      </t.List>
      {{#each @props.tabs as |tab index|}}
        <t.Panel class="a2-tab-panel" @value={{indexOf tab index}}>
          <A2uiNode @node={{tab.child}} />
        </t.Panel>
      {{/each}}
    </Tabs>
  </template>
}

type ModalProps = {
  trigger: ComponentNode
  content: ComponentNode
}

/**
 * The trigger is a node of its own, usually a Button. A button can't hold
 * another, so a Button trigger lends the dialog's trigger its child.
 */
export class Modal extends Component<EmberComponentSignature<ModalProps>> {
  get triggerLabel(): ComponentNode {
    const { trigger } = this.args.props
    // A node's props are a signal (web_core's default, a Preact signal), and
    // the trigger's child doesn't change, so it's read once.
    const props = trigger.props as unknown as { value: { child?: unknown } }
    const child = props.value.child
    return trigger.type === "Button" && isNode(child) ? child : trigger
  }

  <template>
    <Dialog as |d|>
      <d.Trigger class="a2-btn" data-variant="borderless">
        <A2uiNode @node={{this.triggerLabel}} />
      </d.Trigger>
      <d.Backdrop class="a2-backdrop" />
      <d.Content class="a2-dialog" aria-label="Details">
        <A2uiNode @node={{@props.content}} />
        <d.Close class="a2-icon-btn a2-dialog-x" aria-label="Close">{{icon
            X
            14
          }}</d.Close>
      </d.Content>
    </Dialog>
  </template>
}

function isNode(value: unknown): value is ComponentNode {
  return typeof value === "object" && value !== null && "componentId" in value
}
