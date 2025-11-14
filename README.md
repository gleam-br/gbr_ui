# 🎨 Gleam UI lustre library

[Gleam](https://gleam.run/) UI [lustre](https://lustre.build/) library by @gleam-br

🌝 Nothing stateful only stateless this uses only render functions.

[![Package Version](https://img.shields.io/hexpm/v/gbr_ui)](https://hex.pm/packages/gbr_ui)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gbr_ui/)

```sh
gleam add gbr_ui@1
```

```gleam
import lustre
import lustre/element.{type Element}

import gbr/ui
import gbr/ui/svg
import gbr/ui/svg/alert as svg_alert

type Msg

type Model

pub fn main() -> Nil {
  lustre.simple(init, update, view)
  |> lustre.start("body", Nil)
}

fn view(model: Model) -> Element(Msg) {
  let Model(header:, sidebar:) = model
  let content =
    svg.of(32, 32)
      |> svg_alert.success()
      |> svg.render()

  ui.main(header:, sidebar:, content:)
}

// init, update ...
```

Further documentation can be found at <https://hexdocs.pm/gbr_ui>.

## ✏️ Styling

#### Lustre [dev-tools](https://hexdocs.pm/lustre_dev_tools/toml-reference.html)

🚧 **Work in progress** not production ready.

Gleam config `gleam.toml`:

```toml
[tools.lustre.html]
stylesheets = [
  { href = "/build/dev/javascript/gbr_ui/priv/gbr/ui.css" }
]
```

### Tailwind

[Tailwindcss](https://tailwindcss.com/docs/installation) is required to uses this library and show styling classes correctly.

### Vite @tailwindcss/vite

Using tailwind in vite project with [@tailwindcss/vite](https://tailwindcss.com/docs/installation/using-vite) and:

- with [vite-plugin-gleam](https://github.com/gleam-br/vite-plugin-gleam) to translate `import * from "./*.gleam`.
- with alias `@gleam` to gleam build directory, this help the dev team.

Vite config `vite.config.js`:

```js
import path from 'path'
import { defineConfig } from 'vite'
// plugins
import tailwindcss from "@tailwindcss/vite"
import gleam from 'vite-plugin-gleam'

export default defineConfig({
	plugins: [vite_plugin(), tailwindcss()],
	resolve: {
		alias: {
			'@gleam': path.resolve(__dirname, "./build/dev/javascript")
		}
	}
})
```

My style file `main.css`:

```css
@import "@gleam/gbr_ui/priv/gbr/ui.css";

/* my styles here */
```

> Using alias `@gleam`, the dev team greatful.

### Font

Default:

```css
@import url("https://fonts.googleapis.com/css2?family=Outfit:wght@100..900&display=swap");

@theme {
  --font-*: initial;
  --font-gbr-ui: Outfit, sans-serif;
  --default-font-family: --var(--font-gbr-ui);
}
```

#### Lustre [dev-tools](https://hexdocs.pm/lustre_dev_tools/toml-reference.html)

Gleam config `gleam.toml`:

```toml
[tools.lustre.html]
stylesheets = [
  { href = "https://fonts.googleapis.com/css2?family=Outfit:wght@100..900&display=swap" }
]
```

### Breakpoints

```css
@theme {
  --breakpoint-*: initial;
  --breakpoint-2xsm: 375px;
  --breakpoint-xsm: 425px;
  --breakpoint-3xl: 2000px;
  --breakpoint-sm: 640px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 1024px;
  --breakpoint-xl: 1280px;
  --breakpoint-2xl: 1536px;
}
```

### Texts

```css
@theme {
  --text-title-2xl: 72px;
  --text-title-2xl--line-height: 90px;
  --text-title-xl: 60px;
  --text-title-xl--line-height: 72px;
  --text-title-lg: 48px;
  --text-title-lg--line-height: 60px;
  --text-title-md: 36px;
  --text-title-md--line-height: 44px;
  --text-title-sm: 30px;
  --text-title-sm--line-height: 38px;
  --text-theme-xl: 20px;
  --text-theme-xl--line-height: 30px;
  --text-theme-sm: 14px;
  --text-theme-sm--line-height: 20px;
  --text-theme-xs: 12px;
  --text-theme-xs--line-height: 18px;
}
```

### Colors

```css
@theme {
  --color-current: currentColor;
  --color-transparent: transparent;
  --color-white: #ffffff;
  --color-black: #101828;

  --color-theme-pink-500: #ee46bc;
  --color-theme-purple-500: #7a5af8;

  --color-brand-25: #f2f7ff;
  --color-brand-50: #ecf3ff;
  --color-brand-100: #dde9ff;
  --color-brand-200: #c2d6ff;
  --color-brand-300: #9cb9ff;
  --color-brand-400: #7592ff;
  --color-brand-500: #465fff;
  --color-brand-600: #3641f5;
  --color-brand-700: #2a31d8;
  --color-brand-800: #252dae;
  --color-brand-900: #262e89;
  --color-brand-950: #161950;

  --color-blue-light-25: #f5fbff;
  --color-blue-light-50: #f0f9ff;
  --color-blue-light-100: #e0f2fe;
  --color-blue-light-200: #b9e6fe;
  --color-blue-light-300: #7cd4fd;
  --color-blue-light-400: #36bffa;
  --color-blue-light-500: #0ba5ec;
  --color-blue-light-600: #0086c9;
  --color-blue-light-700: #026aa2;
  --color-blue-light-800: #065986;
  --color-blue-light-900: #0b4a6f;
  --color-blue-light-950: #062c41;

  --color-gray-25: #fcfcfd;
  --color-gray-50: #f9fafb;
  --color-gray-100: #f2f4f7;
  --color-gray-200: #e4e7ec;
  --color-gray-300: #d0d5dd;
  --color-gray-400: #98a2b3;
  --color-gray-500: #667085;
  --color-gray-600: #475467;
  --color-gray-700: #344054;
  --color-gray-800: #1d2939;
  --color-gray-900: #101828;
  --color-gray-950: #0c111d;
  --color-gray-dark: #1a2231;

  --color-orange-25: #fffaf5;
  --color-orange-50: #fff6ed;
  --color-orange-100: #ffead5;
  --color-orange-200: #fddcab;
  --color-orange-300: #feb273;
  --color-orange-400: #fd853a;
  --color-orange-500: #fb6514;
  --color-orange-600: #ec4a0a;
  --color-orange-700: #c4320a;
  --color-orange-800: #9c2a10;
  --color-orange-900: #7e2410;
  --color-orange-950: #511c10;

  --color-success-25: #f6fef9;
  --color-success-50: #ecfdf3;
  --color-success-100: #d1fadf;
  --color-success-200: #a6f4c5;
  --color-success-300: #6ce9a6;
  --color-success-400: #32d583;
  --color-success-500: #12b76a;
  --color-success-600: #039855;
  --color-success-700: #027a48;
  --color-success-800: #05603a;
  --color-success-900: #054f31;
  --color-success-950: #053321;

  --color-error-25: #fffbfa;
  --color-error-50: #fef3f2;
  --color-error-100: #fee4e2;
  --color-error-200: #fecdca;
  --color-error-300: #fda29b;
  --color-error-400: #f97066;
  --color-error-500: #f04438;
  --color-error-600: #d92d20;
  --color-error-700: #b42318;
  --color-error-800: #912018;
  --color-error-900: #7a271a;
  --color-error-950: #55160c;

  --color-warning-25: #fffcf5;
  --color-warning-50: #fffaeb;
  --color-warning-100: #fef0c7;
  --color-warning-200: #fedf89;
  --color-warning-300: #fec84b;
  --color-warning-400: #fdb022;
  --color-warning-500: #f79009;
  --color-warning-600: #dc6803;
  --color-warning-700: #b54708;
  --color-warning-800: #93370d;
  --color-warning-900: #7a2e0e;
  --color-warning-950: #4e1d09;
}
```

### Shadows

```css
@theme {
  --shadow-theme-md: 0px 4px 8px -2px rgba(16, 24, 40, 0.1),
    0px 2px 4px -2px rgba(16, 24, 40, 0.06);
  --shadow-theme-lg: 0px 12px 16px -4px rgba(16, 24, 40, 0.08),
    0px 4px 6px -2px rgba(16, 24, 40, 0.03);
  --shadow-theme-sm: 0px 1px 3px 0px rgba(16, 24, 40, 0.1),
    0px 1px 2px 0px rgba(16, 24, 40, 0.06);
  --shadow-theme-xs: 0px 1px 2px 0px rgba(16, 24, 40, 0.05);
  --shadow-theme-xl: 0px 20px 24px -4px rgba(16, 24, 40, 0.08),
    0px 8px 8px -4px rgba(16, 24, 40, 0.03);
  --shadow-datepicker: -5px 0 0 #262d3c, 5px 0 0 #262d3c;
  --shadow-focus-ring: 0px 0px 0px 4px rgba(70, 95, 255, 0.12);
  --shadow-slider-navigation: 0px 1px 2px 0px rgba(16, 24, 40, 0.1),
    0px 1px 3px 0px rgba(16, 24, 40, 0.1);
  --shadow-tooltip: 0px 4px 6px -2px rgba(16, 24, 40, 0.05),
    -8px 0px 20px 8px rgba(16, 24, 40, 0.05);

  --drop-shadow-4xl: 0 35px 35px rgba(0, 0, 0, 0.25),
    0 45px 65px rgba(0, 0, 0, 0.15);
}
```

### Z indexes

```css
@theme {
  --z-index-1: 1;
  --z-index-9: 9;
  --z-index-99: 99;
  --z-index-999: 999;
  --z-index-9999: 9999;
  --z-index-99999: 99999;
  --z-index-999999: 999999;
}
```

### Menus

```css
@utility menu-item {
  @apply relative flex items-center gap-3 px-3 py-2 font-medium rounded-lg text-theme-sm;
}

@utility menu-item-active {
  @apply bg-brand-50 text-brand-500 dark:bg-brand-500/[0.12] dark:text-brand-400;
}

@utility menu-item-inactive {
  @apply text-gray-700 hover:bg-gray-100 hover:text-gray-700 dark:text-gray-300 dark:hover:bg-white/5 dark:hover:text-gray-300;
}

@utility menu-item-icon-active {
  @apply fill-brand-500 dark:fill-brand-400;
}

@utility menu-item-icon-inactive {
  @apply fill-gray-500 group-hover:fill-gray-700 dark:fill-gray-400 dark:group-hover:fill-gray-300;
}

@utility menu-item-arrow {
  @apply absolute top-1/2 right-2.5 -translate-y-1/2;
}

@utility menu-item-arrow-active {
  @apply rotate-180 stroke-brand-500 dark:stroke-brand-400;
}

@utility menu-item-arrow-inactive {
  @apply stroke-gray-500 group-hover:stroke-gray-700 dark:stroke-gray-400 dark:group-hover:stroke-gray-300;
}

@utility menu-dropdown-item {
  @apply text-theme-sm relative flex items-center gap-3 rounded-lg px-3 py-2.5 font-medium;
}

@utility menu-dropdown-item-active {
  @apply bg-brand-50 text-brand-500 dark:bg-brand-500/[0.12] dark:text-brand-400;
}

@utility menu-dropdown-item-inactive {
  @apply text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-white/5;
}

@utility menu-dropdown-badge {
  @apply text-brand-500 dark:text-brand-400 block rounded-full px-2.5 py-0.5 text-xs font-medium uppercase;
}

@utility menu-dropdown-badge-active {
  @apply bg-brand-100 dark:bg-brand-500/20;
}

@utility menu-dropdown-badge-inactive {
  @apply bg-brand-50 group-hover:bg-brand-100 dark:bg-brand-500/15 dark:group-hover:bg-brand-500/20;
}
```

### Scrollbars

```css
@utility no-scrollbar {
  /* Chrome, Safari and Opera */
  &::-webkit-scrollbar {
    display: none;
  }

  -ms-overflow-style: none;
  /* IE and Edge */
  scrollbar-width: none;
  /* Firefox */
}

@utility custom-scrollbar {
  &::-webkit-scrollbar {
    @apply size-1.5;
  }

  &::-webkit-scrollbar-track {
    @apply rounded-full;
  }

  &::-webkit-scrollbar-thumb {
    @apply bg-gray-200 rounded-full;
  }
}
```

### Inputs

```css
@layer utilities {
  /* For Remove Date Icon */
  input[type="date"]::-webkit-inner-spin-button,
  input[type="time"]::-webkit-inner-spin-button,
  input[type="date"]::-webkit-calendar-picker-indicator,
  input[type="time"]::-webkit-calendar-picker-indicator {
    display: none;
    -webkit-appearance: none;
  }
}
```

### Sidebar ajusts

```css
.sidebar:hover {
  width: 290px;
}

.sidebar:hover .logo {
  display: block;
}

.sidebar:hover .logo-icon {
  display: none;
}

.sidebar:hover .sidebar-header {
  justify-content: space-between;
}

.sidebar:hover .menu-group-title {
  display: block;
}

.sidebar:hover .menu-group-icon {
  display: none;
}

.sidebar:hover .menu-item-text {
  display: inline;
}

.sidebar:hover .menu-item-arrow {
  display: block;
}

.sidebar:hover .menu-dropdown {
  display: flex;
}
```

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

## 🌄 Roadmap

- [ ] Unit tests
- [ ] More docs
- [ ] UI form
- [ ] UI select
- [ ] UI box
- [ ] UI header
- [ ] UI sidebar
- [ ] UI breadcrumb
- [ ] UI search
- [ ] UI profile
- [ ] UI notify
- [ ] UI login
  - [ ] basic
  - [ ] provider
- [x] UI layout
- [x] UI core
- [x] UI input
- [x] UI typo
- [x] UI alert
- [x] UI svg
- [x] UI button
- [x] UI checkbox
- [x] GH workflow
  - [x] test & build
  - [x] changelog & issue to doc
  - [x] ~~auto publish~~ manual publish
    - [x] `gleam publish`
