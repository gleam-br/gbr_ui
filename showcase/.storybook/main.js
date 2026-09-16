

/** @type { import('@storybook/html-vite').StorybookConfig } */
export default {
  "stories": [
    "../src/**/*.mdx",
    "../src/**/*.stories.@(js|jsx|mjs|ts|tsx)"
  ],
  "addons": [
    "@chromatic-com/storybook",
    "@storybook/addon-vitest",
    "@storybook/addon-a11y",
    "@storybook/addon-docs"
  ],
  "framework": "@storybook/html-vite",
  "core": {
    "builder": {
      "name": "@storybook/builder-vite",
      "options": {
        "viteConfigPath": new URL("../vite.config.js", import.meta.url).pathname.slice(1)
      },
    },
    "disableTelemetry": true,
    "disableWhatsNewNotifications": true,
  }
};
