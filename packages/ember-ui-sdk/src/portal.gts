import type { TOC } from "@ember/component/template-only"

/** Renders its block into `@to`, or in place without one. */
const Portal: TOC<{
  Args: { to: Element | DocumentFragment | null | undefined }
  Blocks: { default: [] }
}> = <template>
  {{#if @to}}
    {{! @glint-expect-error in-element takes a ShadowRoot where a DocumentFragment is passed }}
    {{#in-element @to insertBefore=null}}{{yield}}{{/in-element}}
  {{else}}
    {{yield}}
  {{/if}}
</template>

export default Portal
