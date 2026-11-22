import { BASIC_CATALOG_ID } from "./catalog.ts"

/*
 * What an agent sends to ask for a trip: one surface that uses every input the
 * ui-sdk catalog replaces. It names the basic catalog, as any agent would, and
 * the page decides which catalog draws it.
 */

const v = "1.0"
const SURFACE = "trip"
const at = (path: string) => ({ "@path": path })
const text = (id: string, value: unknown, variant?: string) => ({
  id,
  component: "Text",
  text: value,
  ...(variant ? { variant } : {}),
})

const destinations = [
  "Lisbon",
  "Kyoto",
  "Reykjavík",
  "Oaxaca",
  "Tbilisi",
  "Hobart",
  "Marrakesh",
  "Valparaíso",
].map((city) => ({ label: city, value: city.toLowerCase() }))

export const initialData = {
  name: "",
  destination: [],
  cabin: ["economy"],
  extras: [],
  date: "",
  time: "",
  nights: 3,
  notes: "",
  member: "",
  itinerary: false,
  status: "",
}

export const messages: unknown[] = [
  {
    version: v,
    createSurface: {
      surfaceId: SURFACE,
      catalogId: BASIC_CATALOG_ID,
      sendDataModel: true,
    },
  },
  {
    version: v,
    updateComponents: {
      surfaceId: SURFACE,
      components: [
        { id: "root", component: "Card", child: "col" },
        {
          id: "col",
          component: "Column",
          align: "stretch",
          children: [
            "title",
            "name",
            "destination",
            "cabin",
            "extras",
            "when",
            "nights",
            "more",
            "itinerary",
            "actions",
            "status",
          ],
        },
        text("title", "### Plan a trip"),
        {
          id: "name",
          component: "TextField",
          label: "Traveler",
          placeholder: "Full name",
          value: at("/name"),
        },
        {
          id: "destination",
          component: "ChoicePicker",
          label: "Destination",
          filterable: true,
          options: destinations,
          value: at("/destination"),
        },
        {
          id: "cabin",
          component: "ChoicePicker",
          label: "Cabin",
          options: [
            { label: "Economy", value: "economy" },
            { label: "Premium", value: "premium" },
            { label: "Business", value: "business" },
          ],
          value: at("/cabin"),
        },
        {
          id: "extras",
          component: "ChoicePicker",
          label: "Extras",
          variant: "multipleSelection",
          options: [
            { label: "Checked bag", value: "bag" },
            { label: "Seat selection", value: "seat" },
            { label: "Lounge access", value: "lounge" },
          ],
          value: at("/extras"),
        },
        {
          id: "when",
          component: "Row",
          children: ["date", "time"],
        },
        {
          id: "date",
          component: "DateTimeInput",
          label: "Departure",
          enableDate: true,
          min: "2026-11-22",
          max: "2027-11-22",
          value: at("/date"),
        },
        {
          id: "time",
          component: "DateTimeInput",
          label: "Pickup",
          enableTime: true,
          value: at("/time"),
        },
        {
          id: "nights",
          component: "Slider",
          label: "Nights",
          min: 1,
          max: 14,
          steps: 13,
          value: at("/nights"),
        },
        {
          id: "more",
          component: "Tabs",
          tabs: [
            { title: "Notes", child: "notes" },
            { title: "Loyalty", child: "member" },
          ],
        },
        {
          id: "notes",
          component: "TextField",
          label: "Notes for the agent",
          variant: "longText",
          value: at("/notes"),
        },
        {
          id: "member",
          component: "TextField",
          label: "Member number",
          variant: "number",
          value: at("/member"),
        },
        {
          id: "itinerary",
          component: "CheckBox",
          label: "Email me the itinerary",
          value: at("/itinerary"),
        },
        {
          id: "actions",
          component: "Row",
          justify: "spaceBetween",
          children: ["rules", "find"],
        },
        {
          id: "rules",
          component: "Modal",
          trigger: "rules_btn",
          content: "rules_body",
        },
        text("rules_btn_text", "Fare rules"),
        {
          id: "rules_btn",
          component: "Button",
          variant: "borderless",
          child: "rules_btn_text",
          action: { event: { name: "open_rules", context: {} } },
        },
        text(
          "rules_body",
          "### Fare rules\n- Free changes up to 24 hours before departure\n- One personal item included\n- Refunds go back to the original card"
        ),
        text("find_text", "Find trips"),
        {
          id: "find",
          component: "Button",
          variant: "primary",
          child: "find_text",
          action: {
            event: {
              name: "find_trips",
              context: {
                name: at("/name"),
                destination: at("/destination"),
                nights: at("/nights"),
                date: at("/date"),
              },
            },
          },
        },
        text("status", at("/status"), "caption"),
      ],
    },
  },
  {
    version: v,
    updateDataModel: { surfaceId: SURFACE, value: initialData },
  },
]

type Action = {
  name: string
  surfaceId: string
  context?: Record<string, unknown>
}

/** The mock agent's answer to an action: messages for the same surface. */
export function respond(action: Action): unknown[] {
  if (action.name !== "find_trips") {
    return []
  }
  const context = action.context ?? {}
  const city =
    destinations.find(
      (d) => d.value === (context["destination"] as string[] | undefined)?.[0]
    )?.label ?? "somewhere"
  const nights = Number(context["nights"]) || 3
  const who = String(context["name"] ?? "").trim() || "you"
  const date = String(context["date"] ?? "") || "any date"
  return [
    {
      version: v,
      updateDataModel: {
        surfaceId: action.surfaceId,
        path: "/status",
        value: `Found 3 trips to ${city} for ${who}: ${nights} nights from ${date}.`,
      },
    },
  ]
}

export { SURFACE }
