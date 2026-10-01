# 📺 GleamBR UI Lustre library

[Gleam](https://gleam.run/) UI [lustre](https://lustre.build/) library by @gleam-br

## Como usar?

```gleam
import lustre/element as el

import gbr/ui/theme

pub fn div_container(state) -> el.Element(msg) {
  // theme design
  let variant = theme.primary()
  let appearance = theme.filled()

  // theme create
  let theme =
    theme.new()
    |> theme.with_design_to_tokens(design_classes)
    |> theme.with_variant(variant:)
    |> theme.with_appearance(appearance:)
    |> theme.with_state(state:)

  // typo view with theme
  theme.div(theme:, attributes: [], elements: [])
}

fn design_classes(variant v, appearance a, state s) {
  case v, a, s {
    theme.VariantPrimary, theme.AppearanceFilled, _ -> [
      lustre.Class("bg-primary-500"),
      lustre.Classes([
        #("opacity-50 cursor-not-allowed", s == theme.StateDisabled),
      ]),
    ]
    _, _, _ -> [
      lustre.Class("bg-secondary-500"),
      lustre.Classes([
        #("opacity-75 cursor-wait", s == theme.StateLoading),
      ]),
    ]
  }
}
```

**Outro exemplo:** Um título utilizando o módulo auxiliar `typo`.

```gleam
import lustre/element as el

import gbr/ui/theme
import gbr/ui/theme/typo

pub fn title(state) -> el.Element(msg) {
  // typography type
  let title = typo.H2
  // theme design
  let variant = theme.primary()
  let appearance = theme.filled()
  // theme create
  let theme =
    theme.new()
    |> theme.with_design_to_tokens(design_classes)
    |> theme.with_variant(variant:)
    |> theme.with_appearance(appearance:)
    |> theme.with_state(state:)

  // typo view with theme
  typo.view(title, theme:, attributes: [], elements: [])
}

fn design_classes(variant v, appearance a, state s) {
  case v, a, s {
    theme.VariantPrimary, theme.AppearanceFilled, theme.StatePressed -> [
      lustre.Class("text-primary-700"),
    ]

    theme.VariantPrimary, theme.AppearanceFilled, _ -> [
      lustre.Classes([
        #("text-primary-500", s == theme.StateIdle),
        #("opacity-50 cursor-wait", s == theme.StateLoading),
      ]),
    ]
    _, _, _ -> [
      lustre.Classes([
        #("text-secondary-500", s == theme.StateIdle),
        #("opacity-50 cursor-not-allowed", s == theme.StateDisabled),
      ]),
    ]
  }
}
```

---

## Objetivos

- Utilizar o mesmo vocabulário para web, mobile, desktop, etc.
- Utilizar as mesmas funções `core` para web, mobile, etc.
- Transportar o estado da UI sem comprometer a experiência de quem está
visualizando os componentes no dispositivo.
- Ter tipos algébricos puros (ADT) que possibilitem desenvolver componentes
visuais e uma experiência rica para quem está visualizando no dispositivo.

## Arquitetura: Type-Safe Styled Systems

**CVA (Class Variance Authority)**

- **UIVariant** (Identidade): Responde à pergunta "Qual é o propósito
dessa peça na interface?". É a ação principal? É um aviso? É uma ação
destrutiva? A identidade não muda se o usuário mexer o mouse.
- **UIAppearance** (Aparência) dita como a "tinta" é aplicada no componente
  - **Filled**: Fundo pintado, texto branco/contraste.
  - **Light** (ou Soft): Fundo bem clarinho, texto escuro.
  - **Ghost**: Sem fundo, com borda. (Alguns chamam de Outlined).
- **UIState** (Interação): Responde à pergunta "O que o usuário (ou a rede)
 está fazendo com essa peça AGORA?".  Ele está com o mouse em cima?
Ele clicou? A rede está lenta e está carregando? O botão foi desativado?

🏆 Meta final para o `theme.gleam`

Se transformar em um motor gráfico capaz de descrever **QUALQUER**
componente de interface no planeta. Estrutura final da nossa ontologia:
- O Espaço (Geometria): UISize e UIShape
- A Alma (Semântica): UIVariant
- A Pintura (Material): UIAppearance
- A Luz e A Física: UIElevation e UIStacking
- A Posição: UIDirection
- O Tempo: UIState
- A Herança: UIAncestor

Teremos 8 dimensões base para representarmos visualmente um componente na
interface do dispositivo.

A ordem no código para construir um elemento do zero até a pintura final:

Estrutura Base (Invisível): Display (flex, grid), alinhamento, transições (transition-all).
- Dimensão 1 - Size (Espaço): padding, height, text-size. (Cria a caixa).
- Dimensão 2 - Shape (Forma): border-radius. (Molda a caixa).
- Dimensão 3 - Elevation (Física): shadow, z-index. (Realça a caixa).
- Dimensão 4 - Designs (Identidade): Fusão de Semântica + Pintura + Estado.
Elas não podem ser calculadas separadamente. A Cor (UIVariant) depende do
preenchimento (UIAppearance) que reage a um determinado estado (UIState).

## Regra da Propriedade do CSS

- **Componente é dono de si mesmo:** Ele dita o seu próprio padding,
background, text-color e border-radius. Se o usuário quer um botão menor,
ele deve usar a ADT `theme.SizeSm`. Se a ADT não atende, ele deve construir
o botão usando usando o componente headless (core).
- **Usuário é dono do espaço exterior (DOM):** O argumento `attributes` serve
EXCLUSIVAMENTE para injetar:
  - **Margens:** mt-4, mb-2 (porque o botão não sabe se ele está perto ou
longe de outro elemento).
  - **Posicionamento:** absolute, z-index.
  - **Metadados do DOM:** id="meu-botao", aria-label, data-testid.
  - **Eventos extras:** on_mouse_enter, on_blur.

## 🔥 O Cálculo da Trindade (O Coração da Pintura)

A "fusão" da pintura acontece cruzando as 3 dimensões:
- UIVariant (Cor) x UIAppearance (Preenchimento) x UIState (tempo):
- Matemática: 9 (Variantes) * 8 (Aparências) * 7 (Estados)
  - Total: 504 combinações visuais únicas!

✨ **A Magia do Gleam:** Graças ao curinga (_), você não precisa escrever
504 blocos de regras em CSS puro. Você mapeia apenas os 10 ou 15 caminhos
felizes que o seu design aprova, e usa o `_, _, _ -> fallback(...)` para
devorar as outras combinações impossíveis/indesejadas em uma linha só!
