/**
 *
 */

import { fn } from 'storybook/test';

import { view } from "./typo_stories.gleam";

export default {
  title: 'UI/Typo',
  args: {
    onAction: fn(),
    label: "Olá, tudo bem.",
  },
  argTypes: { label: { control: 'text', description: 'Qual texto quer ver?' } },
  render: view()
};

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
