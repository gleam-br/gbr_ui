
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
    "disableTelemetry": true,
    "disableWhatsNewNotifications": true,
  }
};
