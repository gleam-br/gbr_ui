# GBR UI Core Components

Este documento mapeia os componentes base (Átomos) da biblioteca `gbr_ui/core`, que formam os tokens estruturais agnósticos de layout.

## Átomos (Tokens Algébricos)
Implementados sob `gbr/ui/theme/lustre`:

- **`a11y.gleam`**: Utilitários para acessibilidade (Aria labels, roles).
- **`badge.gleam`**: Elementos visuais como tags e badges (`typo.span` customizados).
- **`button.gleam`**: Core button structure agnóstico (`primary`, `secondary`, etc).
- **`checkbox.gleam`**: Base de inputs do tipo checkbox.
- **`image.gleam`**: Wrapper seguro para `h.img` e gerenciamento de fallbacks.
- **`input.gleam`**: Estrutura base de inputs textuais.
- **`radio.gleam`**: Base de inputs do tipo radio.
- **`typo.gleam`**: Sistema tipográfico completo (Headings `h1..h6`, Textos, Labels).

## Status Geral
Os componentes aqui devem manter a filosofia de ser **agnósticos a regra de negócio** e seguir os princípios do Design System GBR, provendo as Árvores de Sintaxe Abstrata (AST) fluentes para construção dos nós Lustre.
