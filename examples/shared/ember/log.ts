import { getOwner } from "@ember/owner"

function useLog(context: object) {
  const owner = getOwner(context) as { log?: (message: string) => void }
  return owner?.log ?? ((message: string) => console.log(message))
}

export { useLog }
