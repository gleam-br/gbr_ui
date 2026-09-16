/**
 *
 */

import { withThemeByClassName } from '@storybook/addon-themes';
import "../src/main.css"

/** @type { import('@storybook/html-vite').Preview } */
const preview = {
  parameters: {
    backgrounds: {
      disable: true,
    },
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
    a11y: {
      // 'todo' - show a11y violations in the test UI only
      // 'error' - fail CI on a11y violations
      // 'off' - skip a11y checks entirely
      test: "todo",
    },
  },
  decorators: [
    // 1. O Decorador do Tema
    withThemeByClassName({
      themes: {
        light: '',      // No tema light, não aplica classe
        dark: 'dark',   // No tema dark, aplica a classe "dark"
      },
      defaultTheme: 'light',
      // Garante que a classe seja aplicada no body
      parentSelector: 'body',
    }),

    // 2. O Decorador Global (usar para padding, fontes, etc)
    (Story) => {
      const div = document.createElement('div');
      div.className = 'font-sans p-8 text-slate-900 bg-white dark:bg-slate-900 dark:text-white min-h-screen transition-colors';
      div.appendChild(Story());
      return div;
    },
  ],
};

export default preview;
