import type { TOC } from "@ember/component/template-only"

const isComponent = (value: unknown) => typeof value === "function"

/** Renders a toast's content: text as it is, a component by rendering it. */
const Content: TOC<{ Args: { content: any } }> = <template>
  {{~#if (isComponent @content)~}}{{~#let @content as |C|~}}<C
      />{{~/let~}}{{~else~}}{{~@content~}}{{~/if~}}
</template>

export default Content
