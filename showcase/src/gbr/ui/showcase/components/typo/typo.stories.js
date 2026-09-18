/**
 *
 */

import { fn } from 'storybook/test';

import { view } from "./typo_stories.gleam";

export default {
  title: 'UI/Admin/Typo',
  args: {
    onAction: fn(),
    label: "Olá, tudo bem.",
    shadow: "flat",
  },
  argTypes: {
    label: { control: 'text', description: 'Qual texto quer ver?' },
    shadow: {
      control: 'select',
      options: ['flat', 'inner', 'low', 'high', 'medium', 'inherit']
    },
  },
  render: view()
};

export const ThemeHeader = {
  argTypes: {
    kind: {
      control: 'select', description: 'Qual tipografia quer ver?',
      options: ['h1', 'h2', 'h3', 'h4', 'h5', 'h6']
    },
    args: { kind: "h1", theme: { elevation: "high" } },
  }
}
export const Header = {
  argTypes: {
    kind: {
      control: 'select', description: 'Qual tipografia quer ver?',
      options: ['h1', 'h2', 'h3', 'h4', 'h5', 'h6']
    },
  },
  args: { kind: "h1" },
};

export const Span = {
  argTypes: {
    size: {
      control: 'select',
      options: ['xxs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl']
    }
  },
  args: { kind: "span", size: 'md' },
};

export const Pre = {
  argTypes: {
    size: {
      control: 'select',
      options: ['xxs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl']
    }
  },
  args: { kind: "pre", size: 'md' },
};

export const Paragraph = {
  argTypes: {
    size: {
      control: 'select',
      options: ['xxs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl']
    }
  },
  args: { kind: "p", size: 'md' },
};

export const Label = {
  argTypes: {
    size: {
      control: 'select',
      options: ['xxs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl']
    }
  },
  args: { kind: "label", size: 'md' },
};
