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

export const ButtonDefault = {
  args: { kind: "normal", 'theme.variant': "primary", 'theme.size': "md", label: "Padrão" },
};

export const ButtonSharp = {
  args: { kind: "normal", 'theme.variant': "primary", 'theme.size': "md", 'theme.shape': "sharp", label: "Canto Reto" },
};

export const ButtonPill = {
  args: { kind: "normal", 'theme.variant': "secondary", 'theme.size': "lg", 'theme.shape': "pill", label: "Pílula" },
};

export const ButtonCircle = {
  args: { kind: "normal", 'theme.variant': "tertiary", 'theme.size': "xl", 'theme.shape': "circle", label: "OK" },
};

export const ButtonShapeLeft = {
  args: { 
    kind: "normal", 
    'theme.variant': "info", 
    'theme.size': "lg", 
    'theme.shape': "shape", 
    'theme.shape.size': "lg", 
    'theme.shape.layout': "absolute",
    'theme.shape.layout.absolute': "axis",
    'theme.shape.layout.absolute.x': "start",
    'theme.shape.layout.absolute.y': "center",
    label: "Arredondado à Esquerda"
  },
};

export const ButtonShapeTopRight = {
  args: { 
    kind: "normal", 
    'theme.variant': "warn", 
    'theme.size': "xl", 
    'theme.shape': "shape", 
    'theme.shape.size': "xl", 
    'theme.shape.layout': "absolute",
    'theme.shape.layout.absolute': "axis",
    'theme.shape.layout.absolute.x': "end",
    'theme.shape.layout.absolute.y': "start",
    label: "Canto Sup. Direito"
  },
};
