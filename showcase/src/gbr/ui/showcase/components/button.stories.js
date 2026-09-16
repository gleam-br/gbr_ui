/**
 *
 */

import { fn } from 'storybook/test';
import { render } from "./button_stories.gleam";

export default {
  title: 'UI/Button',
  args: {
    onAction: fn(),
    label: "Olá, clique aqui!",
  },
  argTypes: {
    label: { control: 'text' },
    size: {
      control: 'select',
      options: ['xxs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl']
    }
  },
  render: render()
};

export const Button = {
  args: { kind: "normal", variant: "primary", size: "md" },
  argTypes: {
    kind: {
      control: 'select', options: ['submit', 'normal', 'reset']
    },
    variant: {
      control: 'select', options: ['primary', 'secondary', 'tertiary', 'default']
    },
  }
};
