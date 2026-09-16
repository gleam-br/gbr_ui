import "../src/main.css"

/** @type { import('@storybook/html-vite').Preview } */
const preview = {
  parameters: {
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
    (Story) => {
      const container = document.createElement('div');

      container.className = 'p-8 antialiased min-h-screen';

      container.appendChild(Story());

      return container;
    },
  ],
};

export default preview;
