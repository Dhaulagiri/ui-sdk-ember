declare module "virtual:docs-nav" {
  const pages: {
    path: string
    group: string
    title: string
    description: string
  }[]
  export default pages
}
