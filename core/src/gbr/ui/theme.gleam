////
//// 💎✨ GBR: UI Theme Module
////
//// 🤺 theme.gleam = Vocabulário Visual e Design Token Algébrico.
////
//// Aqui temos um módulo muito especial cheio de tipos algébricos para
//// representarmos matematicamente o mundo externo e como manipulamos o tema
//// visual dos nossos componentes.
////
//// Aqui iremos encontrar as variantes do tema, a aparência dos componentes, o
//// estado em que eles estão, seu tamanho, etc.
////
//// **IDEIA: Que esta biblioteca e vocabulário sejam universais para desenvolver
//// componentes UI para qualquer interface**
////
//// ## Objetivos
////
//// - Utilizar o mesmo vocabulário para web, mobile, desktop, etc.
//// - Utilizar as mesmas funções `core` para web, mobile, etc.
//// - Transportar o estado da UI sem comprometer a experiência de quem está
//// visualizando os componentes no dispositivo.
//// - Ter tipos algébricos puros (ADT) que possibilitem desenvolver componentes
//// visuais e uma experiência rica para quem está visualizando no dispositivo.
////
//// ## Arquitetura: Type-Safe Styled Systems
////
//// **CVA (Class Variance Authority)**
////
//// - **UIVariant** (Identidade): Responde à pergunta "Qual é o propósito
//// dessa peça na interface?". É a ação principal? É um aviso? É uma ação
//// destrutiva? A identidade não muda se o usuário mexer o mouse.
//// - **UIAppearance** (Aparência) dita como a "tinta" é aplicada no componente
////   - **Filled**: Fundo pintado, texto branco/contraste.
////   - **Light** (ou Soft): Fundo bem clarinho, texto escuro.
////   - **Ghost**: Sem fundo, com borda. (Alguns chamam de Outlined).
//// - **UIState** (Interação): Responde à pergunta "O que o usuário (ou a rede)
////  está fazendo com essa peça AGORA?".  Ele está com o mouse em cima?
//// Ele clicou? A rede está lenta e está carregando? O botão foi desativado?
////
//// 🏆 Meta final para o `theme.gleam`
////
//// Se transformar em um motor gráfico capaz de descrever **QUALQUER**
//// componente de interface no planeta. Estrutura final da nossa ontologia:
//// - O Espaço (Geometria): UISize e UIShape
//// - A Alma (Semântica): UIVariant
//// - A Pintura (Material): UIAppearance
//// - A Luz e A Física: UIElevation e UIStacking
//// - A Posição: UIDirection
//// - O Tempo: UIState
//// - A Herança: UIAncestor
////
//// Teremos 8 dimensões base para representarmos visualmente um componente na
//// interface do dispositivo.
////
//// A ordem no código para construir um elemento do zero até a pintura final:
////
//// Estrutura Base (Invisível): Display (flex, grid), alinhamento, transições (transition-all).
//// - Dimensão 1 - Size (Espaço): padding, height, text-size. (Cria a caixa).
//// - Dimensão 2 - Shape (Forma): border-radius. (Molda a caixa).
//// - Dimensão 3 - Elevation (Física): shadow, z-index. (Realça a caixa).
//// - Dimensão 4 - Designs (Identidade): Fusão de Semântica + Pintura + Estado.
//// Elas não podem ser calculadas separadamente. A Cor (UIVariant) depende do
//// preenchimento (UIAppearance) que reage a um determinado estado (UIState).
////
//// ## Regra da Propriedade do CSS
////
//// - **Componente é dono de si mesmo:** Ele dita o seu próprio padding,
//// background, text-color e border-radius. Se o usuário quer um botão menor,
//// ele deve usar a ADT `theme.SizeSm`. Se a ADT não atende, ele deve construir
//// o botão usando usando o componente headless (core).
//// - **Usuário é dono do espaço exterior (DOM):** O argumento `attributes` serve
//// EXCLUSIVAMENTE para injetar:
////   - **Margens:** mt-4, mb-2 (porque o botão não sabe se ele está perto ou
//// longe de outro elemento).
////   - **Posicionamento:** absolute, z-index.
////   - **Metadados do DOM:** id="meu-botao", aria-label, data-testid.
////   - **Eventos extras:** on_mouse_enter, on_blur.
////
//// ## 🔥 O Cálculo da Trindade (O Coração da Pintura)
////
//// A "Fusão" da pintura acontece cruzando as 3 dimensões:
//// - UIVariant (Cor) x UIAppearance (Preenchimento) x UIState (tempo):
//// - Matemática: 9 (Variantes) * 8 (Aparências) * 7 (Estados)
////   - Total: 504 combinações visuais únicas!
////
//// ✨ **A Magia do Gleam:** Graças ao curinga (_), você não precisa escrever
//// 504 blocos de regras em CSS puro. Você mapeia apenas os 10 ou 15 caminhos
//// felizes que o seu design aprova, e usa o `_, _, _ -> fallback(...)` para
//// devorar as outras combinações impossíveis/indesejadas em uma linha só!
////
//// 🌌 O Cálculo do Universo (As 8 Dimensões)
////
//// Se nós pegarmos um único elemento genérico (como um `div` atômico) e
//// permitirmos que o desenvolvedor configure livremente as 8 dimensões, qual
//// será o tamanho da nossa "Ontologia de UI"?
////
//// - Matemática: 9 * 8 * 7 * 7 * 5 * 6 * 8 * 6
////   - Total Exato: 5.080.320 de estados possíveis.
////
//// Mais de **5 MILHÕES** de formas de desenhar um componente! 🤯
////
//// ## Explicando o sufixo `Default` e `Ancestor`
////
//// Para todos tipos de tema, inclusive os (size, shape, elevation, stacking),
//// temos dois sufixos importantes `Ancestor` e `Default`, segue um exemplo
//// usando o `UIVariant`:
////
//// - O VariantAncestor (A Herança): Ele significa "Eu não tenho cor própria,
//// olhe para o meu pai e faça o que ele mandar (ou padrão do dispositivo)"
//// (no CSS, isso é o inherit ou o currentColor).
//// - O VariantDefault (O Reset/Neutro): Ele significa "Eu quero a cor padrão
//// original deste componente, não importa onde eu esteja".
////

import gleam/option.{type Option, None, Some}

import gbr/ui/theme/internal/engine

// -----------------------------------------------------------------------------
//
// -- Tipos
//
// -----------------------------------------------------------------------------

///
/// Dados para construir um tema a partir dos tipos de tema, os design tokens.
///
/// - painter: Dados do pintor do tema, os design tokens em ADTs.
/// - builder: Dados do motor para converter os tipos Gleam em design tokens
/// específicos para a interface visual utilizada.
///
/// **Exemplo**
///
/// Abaixo temos um código utilizando o sistema de tipos Gleam para representar
/// o tema de um elemento HTML `<div>`. Utilizamos como estrutura de dados para
/// nossos design tokens finais, uma tupla `List(#(String, True))`, compatível
/// com a função lustre `attribute.classes()`, que aplica os tokens tailwind
///
/// ```gleam
///  import lustre/attribute as a
///  import lustre/element/html as h
///
///  import gbr/ui/theme
///
///  pub fn main() {
///    let builder_variant = fn (variant) {
///      [
///        #("bg-amber-700", theme.is_primary(variant)),
///        #("bg-gray-500", theme.is_not_primary(variant)),
///      ]
///    }
///
///    theme.new()
///    |> theme.with_variant(theme.primary())
///    |> theme.with_builder_variant(builder_variant)
///    |> theme.view(fn (tokens) {
///      h.div([a.classes(tokens)], [h.text("Olá mundo temático!")])
///    })
///  }
/// ```
///
/// - `tokens`: Representar os tokens finais, possibilita ser qualquer estrutura
/// de dados, é um tipo genérico.
///
pub opaque type UITheme(tokens) {
  UITheme(painter: UIPainter, builder: UIBuilder(tokens))
}

/// Dados para a construção de um tema visual.
///
/// - variant: Variante semântica, conhecido como tema, de um elemento.
/// - appearance: Aparência de um elemento o seu estilo.
/// - state: Estado de um elemento.
/// - size: Escala do tamanho de um elemento.
/// - shape: Formato da superfície de um elemento.
/// - stacking: Como controlar o empilhamento dos elementos.
/// - elevation: Como controlar a sensação de elevação dos elementos.
///
type UIPainter {
  UIPainter(
    variant: UIVariant,
    appearance: UIAppearance,
    state: UIState,
    size: Option(UISize),
    shape: Option(UIShape),
    stacking: Option(UIStacking),
    elevation: Option(UIElevation),
    layout: Option(UILayout),
  )
}

/// **BUILDER**
///
///
type UIBuilder(token) {
  UIBuilder(
    /// Para converter os tokens, iniciais, padrão de estilo.
    ///
    base_to_tokens: fn() -> List(token),
    /// Para converter o tamanho em tokens.
    ///
    size_to_tokens: fn(UISize) -> List(token),
    /// Para converter o formato da superfície em tokens
    ///
    shape_to_tokens: fn(UIShape) -> List(token),
    /// Para converter o empilhamento em tokens
    ///
    stacking_to_tokens: fn(UIStacking) -> List(token),
    /// Para converter a sensação de elevação em tokens
    ///
    elevation_to_tokens: fn(UIElevation) -> List(token),
    /// Para converter a sensação de elevação em tokens
    ///
    layout_to_tokens: fn(UILayout) -> List(token),
    /// Para converter o de design (variante x aparência x estado) em tokens.
    ///
    design_to_tokens: fn(UIVariant, UIAppearance, UIState) -> List(token),
  )
}

/// Variante semântica, conhecido como tema, de um elemento.
///
pub type UIVariant {
  VariantDefault
  /// A variante principal do tema.
  VariantPrimary
  /// A variante secundaria do tema.
  VariantSecondary
  /// A variante de fallback do tema.
  VariantTertiary
  /// A variante de sucesso do tema.
  VariantSuccess
  /// A variante de alerta do tema.
  VariantWarning
  /// A variante de erro do tema.
  VariantError
  /// A variante de info do tema.
  VariantInfo
}

/// Aparência de um elemento o seu estilo.
///
pub type UIAppearance {
  AppearanceDefault
  /// Apresentam fundo de cor sólida, ideal para ações primárias devido à alta
  /// visibilidade.
  AppearanceFilled
  /// Tenha um fundo transparente sem borda e com rótulo de texto. Eles são adequados
  /// para ações secundárias, pois são menos proeminentes visualmente do que
  /// a aparencia sólida.
  AppearanceGhost
  /// Ao sobrepor várias sombras desfocadas com cores brilhantes, você pode criar
  /// um efeito luminoso
  AppearanceLight
  /// Tenha um fundo transparente com borda e rótulo de texto. Eles são adequados
  /// para ações secundárias, pois são menos proeminentes visualmente do que
  /// a aparencia sólida.
  AppearanceOutline
}

/// Estado de um elemento.
///
pub type UIState {
  /// Intocado ou parado (Padrão)
  StateIdle
  /// Aguardando processamento
  StateLoading
  /// Desligado ou não acessível
  StateDisabled
  /// Sendo precionado
  StatePressed
}

/// Formato da superfície de um elemento.
///
/// O "quão redondo" é o elemento não depende do tamanho
pub type UIShape {
  /// Arredondamento
  Shape(UISizeLayout)
  /// Bordas arredondadas perfeito para botões
  ShapeRounded
  /// Bordas totalmente arredondadas (Design iOS/Mobile)
  ShapePill
  /// Círculo perfeito (Para avatares e icon_only)
  ShapeCircle
  /// Quadrado perfeito (0px radius)
  ShapeSharp
}

/// Escala do tamanho de um elemento.
///
/// - Altura, Largura, Fonte e Espaçamento Interno (Padding).
///
pub type UISize {
  /// 2xl
  SizeXxl
  /// xl
  SizeXl
  /// lg
  SizeLg
  /// md
  SizeMd
  /// sm
  SizeSm
  /// xs
  SizeXs
  /// 2xs
  SizeXxs
}

/// Controlar o empilhamento dos elementos no eixo Z.
///
pub type UIStacking {
  /// z-0
  StackBase
  /// z-10
  StackFloat
  /// z-20
  StackSticky
  /// z-30
  StackDropdown
  /// z-40
  StackOverlay
  /// z-50
  StackModal
  /// z-60
  StackToast
  /// z-70
  StackTooltip
}

/// Como controlar a sensação de elevação dos elementos. (sombra)
///
pub type UIElevation {
  /// Grudado no chão (Sem sombra)
  ElevationFlat(Option(UISizeLayout))
  /// Afundado (Sombra interna, útil para inputs)
  ElevationInner(Option(UISizeLayout))
  /// Ultra fino (Botões, Badges, etc)
  ElevationThin(Option(UISizeLayout))
  /// Levemente levantado (Cards, Dropdowns sutis)
  ElevationLow(Option(UISizeLayout))
  /// Flutuando (Modais, Menus flutuantes)
  ElevationMedium(Option(UISizeLayout))
  /// Voando alto (Tooltips, Notificações Toast)
  ElevationHigh(Option(UISizeLayout))
}

/// Define a estratégia de posicionamento no layout.
///
pub type UILayout {
  LayoutFlow(UIFlow)
  LayoutAbsolute(UIAbsolute)
}

/// Direção de um elemento esquerda, direita, etc.
///
pub type UIAbsolute {
  Axis(horizontal: UIAlignment, vertical: UIAlignment)
  AxisX(UIAlignment)
  AxisY(UIAlignment)
}

/// Representa a união de justify-content (main) e align-content (cross).
///
pub type UIFlow {
  /// Layout de fluxo principal referencia ao justify-*.
  Main(justify: UIAlignment)
  /// Layout de fluxo principal referencia ao items-*.
  CrossItems(align: UIAlignment)
  /// Layout de fluxo principal referencia ao content-*.
  CrossContent(align: UIAlignment)
  /// Layout de fluxo referenciando o eixo main, cross content e cross items.
  Flow(main: UIAlignment, cross_content: UIAlignment, cross_items: UIAlignment)
  /// Layout de fluxo referenciando o eixo main e cross items.
  FlowItems(main: UIAlignment, cross_items: UIAlignment)
  /// Layout de fluxo referenciando o eixo main e cross content.
  FlowContent(main: UIAlignment, cross_content: UIAlignment)
}

/// Representa as opções de alinhamento em um eixo genérico
pub type UIAlignment {
  /// e.g. flex-start
  Start
  /// e.g. flex-end
  End
  /// e.g. center
  Center
  /// e.g. space-between
  SpaceBetween
  /// e.g. space-around
  SpaceAround
  /// e.g. space-evenly
  SpaceEvenly
  /// e.g. stretch
  Stretch
}

/// Tipo auxiliar para juntar tamanho e localização de um elemento visual.
///
pub type UISizeLayout =
  #(UISize, UILayout)

// WIP: Como controlar a herança:
// - initial: Define a propriedade para o valor padrão do CSS.
// - inherit: Força o elemento a herdar o valor do elemento pai.
// - all: Usado para forçar todas as propriedades a serem herdadas do pai.
//
// O padrão é recuperar o antecessor e se não encontrar recuperar as variantes
// padrões do dispositivo em que estamos pintando o elemento utilizando o tema
// específico.
//
// pub type UIAncestor {
//   AncestorInitial
//   AncestorInherit
//   AncestorAll
// }

// -----------------------------------------------------------------------------
//
// -- Api
//
// -----------------------------------------------------------------------------

/// **PAINT THEME**
///
/// Converte o tema em tokens de design, utilizando o construtor de tokens.
///
/// - theme: O tema que será convertido.
/// - builder: O construtor de tokens que será utilizado.
/// - with: O tema base que será utilizado.
///
pub fn paint(theme: UITheme(token)) -> List(token) {
  let UITheme(painter: theme, builder:) = theme
  let UIPainter(
    variant:,
    appearance:,
    state:,
    stacking:,
    elevation:,
    size:,
    shape:,
    layout:,
  ) = theme
  let UIBuilder(
    base_to_tokens:,
    design_to_tokens:,
    stacking_to_tokens:,
    elevation_to_tokens:,
    size_to_tokens:,
    shape_to_tokens:,
    layout_to_tokens:,
  ) = builder

  let base = base_to_tokens()
  let stackings =
    option.map(stacking, stacking_to_tokens)
    |> option.unwrap([])
  let elevations =
    option.map(elevation, elevation_to_tokens)
    |> option.unwrap([])
  let sizes =
    option.map(size, size_to_tokens)
    |> option.unwrap([])
  let shapes =
    option.map(shape, shape_to_tokens)
    |> option.unwrap([])
  let layout =
    option.map(layout, layout_to_tokens)
    |> option.unwrap([])

  // O design é a parte mais importante do tema, pois é ele que define a aparência
  let designs = design_to_tokens(variant, appearance, state)

  engine.new(base)
  |> engine.with_size(sizes)
  |> engine.with_shape(shapes)
  |> engine.with_design(designs)
  |> engine.with_stacking(stackings)
  |> engine.with_elevation(elevations)
  |> engine.with_positioning(layout)
  |> engine.resolve()
}

/// Construtor de uma visualização de um elemento injetado, aplicando o tema
/// passado como argumento da função e a base dos tokens do estilo do elemento.
///
/// - theme: Os dados do tema a ser aplicado ao elemento injetado.
/// - build: Os dados de como construir os design tokens a partir do tema.
/// - with: Base de estilos, design tokens, para ser aplicado ao elemento.
/// - to: Função para injetar o construtor de um elemento visual genérico.
///
/// `a`: Tipo fantasma que representa o elemento sendo criado e estilizado.
///
pub fn view(
  apply theme: UITheme(token),
  in to_element: fn(List(token)) -> a,
) -> a {
  paint(theme)
  |> to_element()
}

// -----------------------------------------------------------------------------
//
// -- Construtores (Builder)
//
// -----------------------------------------------------------------------------

/// **NOVO THEME BUILDER**
///
/// Criar novo tema e motor de elementos visuais estilizados.
///
/// - theme: Cria um tema padrão.
/// - builder: Cria um construtor de temas padrão, uma lista do tipo genérico.
///
pub fn new() -> UITheme(tokens) {
  UITheme(painter: painter(), builder: builder())
}

///
pub fn with_variant(
  theme: UITheme(tokens),
  variant variant: UIVariant,
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, variant:))
}

///
pub fn with_appearance(
  theme: UITheme(tokens),
  appearance appearance: UIAppearance,
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, appearance:))
}

///
pub fn with_state(
  theme: UITheme(tokens),
  state state: UIState,
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, state:))
}

///
pub fn with_design(
  theme: UITheme(tokens),
  variant variant: UIVariant,
  appearance appearance: UIAppearance,
  state state: UIState,
) -> UITheme(tokens) {
  UITheme(
    ..theme,
    painter: UIPainter(..theme.painter, variant:, appearance:, state:),
  )
}

///
pub fn with_size(
  theme: UITheme(tokens),
  size size: Option(UISize),
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, size:))
}

///
pub fn with_shape(
  theme: UITheme(tokens),
  shape shape: Option(UIShape),
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, shape:))
}

///
pub fn with_elevation(
  theme: UITheme(tokens),
  elevation: Option(UIElevation),
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, elevation:))
}

///
pub fn with_stacking(
  theme: UITheme(tokens),
  stacking stacking: Option(UIStacking),
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, stacking:))
}

///
pub fn with_layout(
  theme: UITheme(tokens),
  layout layout: Option(UILayout),
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, layout:))
}

/// Remove o empilhamento do elemento.
///
pub fn without_stacking(theme: UITheme(tokens)) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, stacking: None))
}

/// Remove a elevação do elemento
///
pub fn without_elevation(theme: UITheme(tokens)) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, elevation: None))
}

/// Remove o tamanho de um elemento.
///
pub fn without_size(theme: UITheme(tokens)) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, size: None))
}

/// Remove a superfície de um elemento
///
pub fn without_shape(theme: UITheme(tokens)) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, shape: None))
}

/// Tamanho padrão, caso o tema não contenha um tamanho determinado.
///
pub fn with_size_default(
  theme: UITheme(token),
  size: UISize,
) -> UITheme(token) {
  let size = option.unwrap(theme.painter.size, size)

  UITheme(..theme, painter: UIPainter(..theme.painter, size: Some(size)))
}

/// Empilhamento padrão, caso o tema não contenha um determinado.
///
pub fn with_stacking_default(
  theme: UITheme(token),
  stacking: UIStacking,
) -> UITheme(token) {
  let stacking = option.unwrap(theme.painter.stacking, stacking)

  UITheme(
    ..theme,
    painter: UIPainter(..theme.painter, stacking: Some(stacking)),
  )
}

/// Elevação padrão, caso o tema não contenha um determinado.
///
pub fn with_elevation_default(
  theme: UITheme(token),
  elevation: UIElevation,
) -> UITheme(token) {
  let elevation = option.unwrap(theme.painter.elevation, elevation)

  UITheme(
    ..theme,
    painter: UIPainter(..theme.painter, elevation: Some(elevation)),
  )
}

/// Superfície padrão, caso o tema não contenha um determinado.
///
pub fn with_shape_default(
  theme: UITheme(token),
  shape: UIShape,
) -> UITheme(token) {
  let shape = option.unwrap(theme.painter.shape, shape)

  UITheme(..theme, painter: UIPainter(..theme.painter, shape: Some(shape)))
}

/// Converte para tokens iniciais, padrão, de estilização.
///
pub fn with_base_to_tokens(
  theme: UITheme(token),
  base_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, base_to_tokens:))
}

/// Converte uma variante do tema em tokens.
///
pub fn with_design_to_tokens(
  theme: UITheme(token),
  design_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, design_to_tokens:))
}

/// Converte uma pilha visual do tema em tokens.
///
pub fn with_stacking_to_tokens(
  theme: UITheme(token),
  stacking_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, stacking_to_tokens:))
}

/// Converte uma elevação do tema em tokens.
///
pub fn with_elevation_to_tokens(
  theme: UITheme(token),
  elevation_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, elevation_to_tokens:))
}

/// Converte um tamanho do tema em tokens.
///
pub fn with_size_to_tokens(
  theme: UITheme(token),
  size_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, size_to_tokens:))
}

/// Converte uma superfície visual do tema em tokens.
///
pub fn with_shape_to_tokens(
  theme: UITheme(token),
  shape_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, shape_to_tokens:))
}

/// Converte um tamanho do tema em tokens.
///
pub fn with_layout_to_tokens(
  theme: UITheme(token),
  layout_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, layout_to_tokens:))
}

// -----------------------------------------------------------------------------
//
// --- Construtores
//
// -----------------------------------------------------------------------------

///
pub fn primary() -> UIVariant {
  VariantPrimary
}

///
pub fn secondary() -> UIVariant {
  VariantSecondary
}

///
pub fn tertiary() -> UIVariant {
  VariantTertiary
}

///
pub fn info() -> UIVariant {
  VariantInfo
}

///
pub fn success() -> UIVariant {
  VariantSuccess
}

///
pub fn waring() -> UIVariant {
  VariantWarning
}

///
pub fn error() -> UIVariant {
  VariantError
}

///
pub fn filled() -> UIAppearance {
  AppearanceFilled
}

///
pub fn ghost() -> UIAppearance {
  AppearanceGhost
}

///
pub fn light() -> UIAppearance {
  AppearanceLight
}

///
pub fn idle() -> UIState {
  StateIdle
}

///
pub fn disabled() -> UIState {
  StateDisabled
}

///
pub fn pressed() -> UIState {
  StatePressed
}

///
pub fn loading() -> UIState {
  StateLoading
}

///
pub fn shape_sharp() -> UIShape {
  ShapeSharp
}

///
pub fn shape_pill() -> UIShape {
  ShapePill
}

///
pub fn shape_circle() -> UIShape {
  ShapeCircle
}

///
pub fn shape_rounded() -> UIShape {
  ShapeRounded
}

///
pub fn shape_rounded_all(size: UISize) -> UIShape {
  rounded_absolute(size, AxisX(Center))
}

///
pub fn rounded_absolute(size: UISize, absolute: UIAbsolute) -> UIShape {
  Shape(#(size, layout_absolute(absolute)))
}

///
pub fn layout_flow_main(main) {
  Main(main)
  |> layout_flow()
}

///
pub fn layout_flow_cross_items(main) {
  CrossItems(main)
  |> layout_flow()
}

///
pub fn layout_flow_cross_content(main) {
  CrossContent(main)
  |> layout_flow()
}

///
pub fn layout_flow_items(main, cross_items) {
  FlowItems(main:, cross_items:)
  |> layout_flow()
}

///
pub fn layout_flow_content(main, cross_content) {
  FlowContent(main:, cross_content:)
  |> layout_flow()
}

pub fn layout_flow(flow) {
  LayoutFlow(flow)
}

///
pub fn layout_absolute_axis(horizontal, vertical) {
  Axis(horizontal:, vertical:)
  |> layout_absolute()
}

///
pub fn layout_absolute(axis) {
  LayoutAbsolute(axis)
}

//
// --- HELPER
//

///
pub fn is_primary(variant: UIVariant) -> Bool {
  VariantPrimary == variant
}

///
pub fn is_not_primary(variant: UIVariant) -> Bool {
  !is_primary(variant)
}

pub fn size_decrement(size: UISize) {
  size_decrement_count(size, 0)
}

pub fn size_decrement_count(size: UISize, count: Int) {
  let size = case size {
    SizeXxl -> SizeXl
    SizeXl -> SizeLg
    SizeLg -> SizeMd
    SizeMd -> SizeSm
    SizeSm -> SizeXs
    SizeXs -> SizeXxs
    SizeXxs -> SizeXxs
  }

  case count {
    0 -> size
    count -> size_decrement_count(size, count - 1)
  }
}

/// Rotaciona todo o tema de layout. (rotate-180)
///
pub fn layout_rotate(layout: UILayout) {
  case layout {
    LayoutFlow(flow) ->
      case flow {
        Main(justify:) -> Main(alignment_rotate(justify))
        CrossItems(align:) -> CrossItems(alignment_rotate(align))
        CrossContent(align:) -> CrossContent(alignment_rotate(align))
        Flow(main:, cross_content:, cross_items:) ->
          Flow(
            main: alignment_rotate(main),
            cross_content: alignment_rotate(cross_content),
            cross_items: alignment_rotate(cross_items),
          )
        FlowItems(main:, cross_items:) ->
          FlowItems(
            main: alignment_rotate(main),
            cross_items: alignment_rotate(cross_items),
          )
        FlowContent(main:, cross_content:) ->
          FlowContent(
            main: alignment_rotate(main),
            cross_content: alignment_rotate(cross_content),
          )
      }
      |> LayoutFlow
    LayoutAbsolute(absolute) ->
      case absolute {
        Axis(horizontal:, vertical:) ->
          Axis(
            horizontal: alignment_rotate(horizontal),
            vertical: alignment_rotate(vertical),
          )
        AxisX(x) -> AxisX(x)
        AxisY(y) -> AxisY(y)
      }
      |> LayoutAbsolute
  }
}

/// Rotaciona o alinhamento de um tema de layout. (rotate-180)
///
pub fn alignment_rotate(align: UIAlignment) {
  case align {
    Start -> End
    End -> Start
    Center -> Center
    SpaceBetween -> SpaceAround
    SpaceAround -> SpaceBetween
    SpaceEvenly -> Stretch
    Stretch -> SpaceEvenly
  }
}

//
// --- CRIAR TEMA E BUILDER PADRÃO (Interno)
//

/// **NOVO TEMA PADRÃO**
///
/// Contrutor de um tema UI.
///
fn painter() -> UIPainter {
  UIPainter(
    size: None,
    shape: None,
    stacking: None,
    elevation: None,
    variant: VariantDefault,
    appearance: AppearanceDefault,
    state: StateIdle,
    layout: None,
  )
}

/// **NOVO BUILDER**
///
/// Contrato para o construtor de tokens a partir dos nossos tipos algébricos.
///
/// > O tipo UITheme depende, exclusivamente do UIBuilder para converter os tipos
/// semânticos do tema em tokens para a interface UI final.
///
fn builder() -> UIBuilder(token) {
  UIBuilder(
    base_to_tokens: fn() { [] },
    design_to_tokens: fn(_variant, _appearance, _state) { [] },
    stacking_to_tokens: fn(_stacking) { [] },
    elevation_to_tokens: fn(_elevation) { [] },
    size_to_tokens: fn(_size) { [] },
    shape_to_tokens: fn(_shape) { [] },
    layout_to_tokens: fn(_direction) { [] },
  )
}
