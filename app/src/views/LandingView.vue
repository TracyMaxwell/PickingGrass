<script setup lang="ts">
import logo from '@/assets/logo.svg'
</script>

<template>
  <div class="landing">

    <div class="card hero-card">
      <img :src="logo" alt="PickingGrass" class="hero-logo" />
      <div class="hero-text">
        <h1>PickingGrass</h1>
        <p>
          Apply Markov chain models to sports data to uncover patterns,
          predict outcomes, and explore state transitions — all in one place.
        </p>
      </div>
    </div>

    <div class="bottom-row">

      <div class="card get-started-card">
        <h2>Get Started</h2>
        <div class="gif-placeholder">
          <span>Editor preview coming soon</span>
        </div>
        <RouterLink :to="{ name: 'sign-in' }" class="cta-btn">Open the Editor</RouterLink>
      </div>

      <div class="card docs-card">
        <h2>Documentation</h2>
        <p>
          Learn how to load your data, configure your model parameters,
          and interpret results. Guides, references, and examples all in one place.
        </p>
        <RouterLink :to="{ name: 'docs' }" class="cta-btn secondary">View Docs</RouterLink>
      </div>

    </div>
  </div>
</template>

<style scoped>
.landing {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  padding: 2.5rem 2rem;
  max-width: 1100px;
  margin: 0 auto;
  width: 100%;
}

.card {
  background-color: var(--pg-accent-bg);
  border: 1px solid var(--pg-accent-bg-mute);
  border-radius: 14px;
  padding: 2rem 2.5rem;
}

.hero-card {
  display: flex;
  align-items: center;
  gap: 2rem;
}

.hero-logo {
  width: 180px;
  flex-shrink: 0;
}

.hero-text h1 {
  font-size: 2rem;
  font-weight: 700;
  color: var(--pg-accent-dark);
  margin-bottom: 0.75rem;
}

.hero-text p {
  font-size: 1rem;
  color: var(--pg-text);
  line-height: 1.7;
  max-width: 600px;
}

.bottom-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
}

.get-started-card,
.docs-card {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

h2 {
  font-size: 1.3rem;
  font-weight: 700;
  color: var(--pg-accent-dark);
}

.docs-card p {
  font-size: 0.95rem;
  color: var(--pg-text);
  line-height: 1.7;
  flex: 1;
}

.gif-placeholder {
  flex: 1;
  min-height: 220px;
  border: 2px dashed var(--pg-accent-bg-mute);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--pg-text-muted);
  font-size: 0.9rem;
  background-color: var(--pg-surface-soft);
}

.cta-btn {
  display: inline-block;
  padding: 0.65rem 1.5rem;
  border-radius: 7px;
  font-size: 0.95rem;
  font-weight: 600;
  text-decoration: none;
  text-align: center;
  background-color: var(--pg-accent);
  color: var(--pg-accent-text);
  transition: background-color 0.15s;
}

.cta-btn:hover {
  background-color: var(--pg-accent-dark);
}

.cta-btn.secondary {
  background-color: transparent;
  color: var(--pg-accent-dark);
  border: 2px solid var(--pg-accent);
}

.cta-btn.secondary:hover {
  background-color: var(--pg-accent-bg-mute);
}

@media (max-width: 700px) {
  .bottom-row {
    grid-template-columns: 1fr;
  }

  .hero-card {
    flex-direction: column;
    text-align: center;
  }
}
</style>
