[![Package Version](https://img.shields.io/hexpm/v/gbr_ui_storybook)](https://hex.pm/packages/gbr_ui_storybook)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gbr_ui_storybook/)


# 📺 GleamBR UI Storybook library

[Gleam](https://gleam.run/) UI [lustre](https://lustre.build/) com o bundler [vitejs](https://vite.dev) e [storybook](https://storybook.js.org).

## Como usar?

```sh
npm create vite-lustre --overwrite test_gleam_storybook
cd test_gleam_storybook

npm install vite-plugin-gleam
npx storybook@latest init --type html --builder vite

gleam add gbr_ui_showcase
```

Os comandos acima irão criar o projeto `test_gleam_storybook`, instalar o plugin Gleam para o Vitejs, inicializar as configurações e dependências do storybook e instalar o pacote Gleam `gbr_ui_showcase`.

Depois temos que configurar nosso storybook para recuperar as configurações do vite.config.js no projeto, em `.storybook/main.js`:

```
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
```

Agora vamos criar uma história para nosso storybook, aqui iremos criar dois arquivos de código fonte um em Gleam e outro em java script:

> Este exemplo utiliza a biblioteca `gbr_ui`.

Arquivo `typo_stories.gleam`: Implementação da visualização do componente lustre no storybook.

```gleam
import gleam/dynamic/decode

import gbr/ui/storybook
import gbr/ui/theme
import gbr/ui/theme/lustre
import gbr/ui/theme/lustre/typo

pub fn view() {
  storybook.render(do_view)
}

fn do_view(args) {
  let #(kind, label) = decode_args(args)

  theme.new()
  |> theme.with_size_to_tokens(fn(size) {
    [
      case size {
        theme.SizeAncestor(_) -> ""
        theme.SizeXxl -> "text-2xl"
        theme.SizeXl -> "text-xl"
        theme.SizeLg -> "text-lg"
        theme.SizeMd -> "text-md"
        theme.SizeSm -> "text-sm"
        theme.SizeXs -> "text-xs"
        theme.SizeXxs -> "text-xs"
      }
      |> lustre.Class,
    ]
  })
  |> typo.text(kind, _, label, [], [])
}

fn decode_args(args) {
  let label = storybook.decode(args, "label", decode.string, "Olá mundo!")
  let kind = storybook.decode(args, "kind", decode.string, "span")
  let size = storybook.decode(args, "size", decode.string, "md")

  let size = case size {
    "xxs" -> theme.SizeXxs
    "xs" -> theme.SizeXs
    "sm" -> theme.SizeSm
    "md" -> theme.SizeMd
    "lg" -> theme.SizeLg
    "xl" -> theme.SizeXl
    "2xl" -> theme.SizeXxl
    _ -> theme.SizeMd
  }

  let kind = case kind {
    "h1" -> typo.H1
    "h2" -> typo.H2
    "h3" -> typo.H3
    "h4" -> typo.H4
    "h5" -> typo.H5
    "h6" -> typo.H6
    "p" -> typo.Paragraph(size)
    "pre" -> typo.Pre(size)
    "span" -> typo.Span(size)
    "label" -> typo.Label(size)
    _ -> typo.H1
  }

  #(kind, label)
}
```

Arquivo `typo.stories.js`: A configuração storybook para o componente e iterações.

```js
import { fn } from 'storybook/test';

import { view } from "./typo_stories.gleam";

export default {
  title: 'UI/Typo',
  args: {
    onAction: fn(),
    label: "Olá, tudo bem.",
    size: "md",
  },
  argTypes: {
    label: { control: 'text', description: 'Qual texto quer ver?' },
    kind: {
      control: 'select', description: 'Qual tipografia quer ver?',
      options: ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p', 'pre', 'span']
    },
    size: {
      control: 'select', description:
        'Qual o tamanho do texto, não é válido para cabeçalhos',
      options: ['xxs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl']
    }
  },
  render: view()
};

export const H1 = {
  args: { kind: "h1" },
};

export const H2 = {
  args: { kind: "h2" },
};

export const H3 = {
  args: { kind: "h3" },
};

export const H4 = {
  args: { kind: "h4" },
};

export const H5 = {
  args: { kind: "h5" },
};

export const H6 = {
  args: { kind: "h6" },
};

export const Span = {
  args: { kind: "span" },
};

export const Pre = {
  args: { kind: "pre" },
};

export const Paragraph = {
  args: { kind: "p" },
};

export const Label = {
  args: { kind: "label" },
};

```

Estrutura de diretórios:

```text
-> test_gleam_storybook/
--> .storybook/
----> main.js
----> preview.js
--> src/
----> stories/
--------> typo_stories.gleam
--------> typo.stories.js

**Executando**

```sh
npm run storybook
```
