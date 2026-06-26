---
name: r3f-three
description: >-
  React Three Fiber and WebGL implementation for interactive 3D scenes. Use when
  building R3F scenes, Three.js environments, WebGL canvases, GLTF viewers,
  orbit controls, lighting setups, or debugging black canvas / SSR WebGL errors.
  Stack picker before coding. Proof scene gate before any environment work.
---

# R3F / Three.js implementation lane

**Not** a 2D UI skill. For dashboards and Tailwind, use Impeccable + ui-ux-pro-max react-tailwind. For 3D, follow this skill first.

## When to apply

- User asks for 3D scene, environment, WebGL hero, immersive canvas, GLTF/GLB viewer
- Editing scenes/, *Scene*.tsx, or files importing @react-three/fiber
- Debugging black canvas, SSR WebGL errors, zero-size canvas

## When NOT to apply

- Pure CSS 3D transforms / parallax (Tailwind only)
- Static product spin -> prefer @google/model-viewer or Spline embed
- Dashboard tables, forms, SaaS UI -> frontend module / Impeccable

## Stack picker (choose before writing code)

| Need | Use | Avoid |
|------|-----|-------|
| Interactive scene, custom logic | R3F + @react-three/drei | Raw Three.js in React without R3F |
| Single GLB spin on marketing page | model-viewer or Spline iframe | Full R3F stack |
| Fake depth on landing | CSS transform perspective | WebGL |
| Physics-heavy game | Babylon.js (out of scope) | Hand-rolled physics day one |

## Proof scene gate (mandatory)

Never start with terrain, city, particles, or HDRI environment.

Ship this first (copy from scenes/ProofScene.tsx if present):

1. Wrapper with explicit size (h-screen w-full or fixed aspect box)
2. Canvas with camera position [3, 3, 3], fov 50
3. ambientLight (~0.4) + directionalLight position [5, 5, 5]
4. Visible mesh with distinct color
5. OrbitControls from drei

Only after proof renders and orbits -> stage -> assets -> polish.

## Next.js / SSR

Use `'use client'`, `dynamic(() => import('./ProofScene'), { ssr: false })`, wrapper with non-zero height.

## Black screen debug

| Cause | Fix |
|-------|-----|
| No lights | ambient + directional |
| Camera inside mesh | move camera back |
| Scale wrong | normalize model scale |
| Canvas height 0 | explicit wrapper height |
| SSR | dynamic import ssr false |

## Lookup

`python .cursor/skills/ui-ux-pro-max/scripts/search.py "canvas ssr" --stack react-three-fiber`

Inspiration: `.cursor/design-refs/3d.md`

## Milestones

1. Proof - box + lights + orbit
2. Stage - Grid, ground, Environment
3. Content - GLTF + Draco
4. Polish - after 60fps proof
