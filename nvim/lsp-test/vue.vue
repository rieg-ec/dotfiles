<template>
  <div class="w-full">
    <h1>{{ message }}</h1>
    <button @click="increment">Count: {{ count }}</button>
    <p>{{ user.name }}</p>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

// This should show type inference
const count = ref(0)
const message = ref('Hello TypeScript')

// This should show type errors if you access wrong properties
interface User {
  name: string
  age: number
}

const user: User = {
  name: 'John',
  age: 30
}

// This should provide autocomplete
function increment() {
  count.value++
}

// This should show type error if uncommented
// const wrong: string = 123
</script>

<style scoped>
h1 {
  color: blue;
}
</style>
