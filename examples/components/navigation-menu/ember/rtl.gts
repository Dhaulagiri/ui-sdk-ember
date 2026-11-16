import { ChevronDown } from "lucide"
import { NavigationMenu } from "ember-ui-sdk/navigation-menu"
import { icon } from "../../../shared/ember/icon"

const sections = [
  {
    value: "guides",
    label: "الأدلة",
    links: [
      {
        title: "مقدمة",
        href: "#",
        description: "مكونات بلا أنماط بنواة واحدة لكل إطار عمل.",
      },
      {
        title: "التثبيت",
        href: "#",
        description: "أضف الحزمة لإطار عملك واعرض أول جزء.",
      },
      {
        title: "التنسيق",
        href: "#",
        description: "نسّق الأجزاء بسمات البيانات ومتغيرات CSS.",
      },
    ],
  },
  {
    value: "components",
    label: "المكونات",
    links: [
      {
        title: "مربع تنبيه",
        href: "#",
        description: "يطلب قرارًا قبل استخدام أي شيء آخر في الصفحة.",
      },
      {
        title: "بطاقة التمرير",
        href: "#",
        description: "معاينة لما يشير إليه الرابط.",
      },
      {
        title: "علامات التبويب",
        href: "#",
        description: "تعرض لوحة واحدة من المحتوى في كل مرة.",
      },
    ],
  },
]

<template>
  <div dir="rtl">
    <NavigationMenu aria-label="الرئيسية" as |n|>
      <n.List as |l|>
        {{#each sections key="value" as |section|}}
          <l.Item @value={{section.value}} as |i|>
            <i.Trigger>
              {{section.label}}
              {{icon ChevronDown}}
            </i.Trigger>
            <i.Content as |c|>
              <ul>
                {{#each section.links key="title" as |link|}}
                  <li>
                    <c.Link href={{link.href}}>
                      <span>{{link.title}}</span>
                      <span data-slot="hint">{{link.description}}</span>
                    </c.Link>
                  </li>
                {{/each}}
              </ul>
            </i.Content>
          </l.Item>
        {{/each}}
        <l.Item as |i|>
          <i.Link href="#">المستندات</i.Link>
        </l.Item>
      </n.List>
      <n.Viewport @sideOffset={{8}} />
    </NavigationMenu>
  </div>
</template>
