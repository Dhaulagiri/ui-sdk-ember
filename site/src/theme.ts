const key = "theme"

function read() {
  try {
    const saved = localStorage.getItem(key)
    return saved === "light" || saved === "dark" ? saved : undefined
  } catch {
    return undefined
  }
}

function apply(theme: "light" | "dark" | undefined) {
  if (theme) {
    document.documentElement.dataset.theme = theme
  } else {
    delete document.documentElement.dataset.theme
  }
}

function isDark() {
  const theme = read()
  return theme
    ? theme === "dark"
    : matchMedia("(prefers-color-scheme: dark)").matches
}

function toggle() {
  const next = isDark() ? "light" : "dark"
  try {
    localStorage.setItem(key, next)
  } catch {}
  apply(next)
  return next === "dark"
}

export { apply, isDark, read, toggle }
