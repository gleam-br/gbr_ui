# Guia do Agente AI - Biblioteca `gbr_ui`

> **SSOT Consolidado no Monorepo:** Todas as diretrizes deste arquivo, de [`libs/gbr_ui_admin/AGENT.md`](../gbr_ui_admin/AGENT.md) e dos ADRs ([`0001`](./docs/adr/0001-ui-architecture.md) a [`0004`](./docs/adr/0004-color-architecture.md)) estão consolidadas no subagente especialista [`gbr-ui-expert.md`](../../.agents/plugins/core-team/agents/gbr-ui-expert.md). Este arquivo é mantido como referência local do submódulo `gbr_ui`.

---

## 1. Escopo

`gbr_ui` é o "Core" do nosso ecossistema Visual e o coração do nosso Design System.
O seu propósito é disponibilizar componentes "Dumb" (Puros, sem lógica de negócio), tipificados de ponta a ponta e estruturados a partir da metodologia **Atomic Design**.

Aqui adotamos um sistema próprio de **Type-Safe Styled Systems / Typed Tokens** via **AST (Abstract Syntax Tree)** (`theme.gleam`), em que todos os estilos são primeiramente modelos de dados (AST) e só no final são injetados como classes do Tailwind via geradores (`theme.to_attributes(t)`).

**Objetivo Central:** Oferecer uma **DX (Developer Experience)** e **UX (User Experience)** imbatíveis.

---

## 2. Restrições

- **Dumb Components Somente:** Todo componente deve receber propriedades via seu modelo/atributos e emitir mensagens/ações. Eles NÃO conhecem o estado global da aplicação.
- **TEA (The Elm Architecture):** Respeite o modelo FP TEA. O fluxo é sempre `Model -> View -> Msg`.
- **Atomic Design:** Comece pelo básico (Átomos) antes de fazer composições complexas (Moléculas e Organismos). Não misture abstrações.
- **AST First:** NUNCA escreva strings de TailwindCss avulsas dentro da view final se elas pertencem a uma configuração temática. Sempre estenda ou utilize os construtores em `theme.gleam` (ex.: `theme.new() |> theme.variant(...)`).
- **Sem Side-Effects:** Funções de view (`view`) devem ser puras. Sem chamadas impuras, sem IO ou dependências acopladas.

---

## 3. Verificações

1. **Reaproveitamento:** Antes de criar um componente, verifique se ele já não existe ou se não pode ser construído via composição no diretório de core.
2. **Showcase / Storybook:** Todo novo componente DEVE ser testado e refletido no app de Showcase.
3. **Padrão Lustre:** Se o componente retorna um HTML do Lustre (element.Element), certifique-se de não encadear propriedades que quebrem a árvore HTML (fechamento adequado das tags e injeção transparente dos atributos a.Attribute adicionais).
