/**
 *
 */

import { fn } from 'storybook/test';
import { render } from "./button_stories.gleam";
import { UIThemeTypes, UIThemeArgs } from "../base.storybook";

export default {
  title: 'UI/Admin/Button',
  args: {
    ...UIThemeArgs,
    label: "Olá, clique aqui!",
    onAction: fn(),
  },
  argTypes: {
    label: { control: 'text' },
    kind: { control: 'select', options: ['submit', 'normal', 'reset'] },
    ...UIThemeTypes({
      appearance: { arg: 'disable', eq: 'true' },
      state: { arg: 'disable', eq: 'true' },
      layout: { arg: 'disable', eq: 'true' }
    }),
  },
  render: render()
};

export const Button = {
  args: { kind: "normal", 'theme.variant': "primary", 'theme.size': "md" },
};
