import { Separator } from "ember-ui-sdk/separator"

<template>
  <nav aria-label="Legal" data-slot="row">
    <a href="#privacy">Privacy</a>
    <Separator @orientation="vertical" />
    <a href="#terms">Terms</a>
    <Separator @orientation="vertical" />
    <a href="#cookies">Cookies</a>
  </nav>
</template>
