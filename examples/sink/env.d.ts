// The one Vite API the sink uses, typed here since examples don't depend on Vite.
interface ImportMeta {
  glob<T>(
    pattern: string,
    options: { eager: true; import: string }
  ): Record<string, T>
}
