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
////   - **Flat** (ou Clear): Sem fundo, sem borda, só o texto pintado.
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

import gleam/list
import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element
import lustre/element/html as h

import gbr/ui/internal/engine

// -----------------------------------------------------------------------------
//
// -- Tipos
//
// -----------------------------------------------------------------------------

///
/// Dados para construir um tema a partir dos tipos de tema, os design tokens.
///
/// - theme: Dados do tema, os design tokens.
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
pub opaque type UIThemeBuilder(tokens) {
  UIThemeBuilder(theme: UITheme, builder: UIBuilder(tokens))
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
type UITheme {
  UITheme(
    variant: UIVariant,
    appearance: UIAppearance,
    state: UIState,
    size: Option(UISize),
    shape: Option(UIShape),
    stacking: Option(UIStacking),
    elevation: Option(UIElevation),
    direction: Option(UIDirection),
  )
}

///
///
type UIBuilder(token) {
  UIBuilder(
    base_to_tokens: BaseToTokens(token),
    design_to_tokens: DesignToTokens(token),
    size_to_tokens: SizeToTokens(token),
    shape_to_tokens: ShapeToTokens(token),
    stacking_to_tokens: StackingToTokens(token),
    elevation_to_tokens: ElevationToTokens(token),
    direction_to_tokens: DirectionToTokens(token),
  )
}

/// Variante semântica, conhecido como tema, de um elemento.
///
/// - VariantAncestor: A variante que recupera as variantes do seu elemento pai
/// - VariantPrimary: A variante principal do tema.
/// - VariantSecondary: A variante secundaria do tema.
/// - VariantTertiary: A variante de fallback do tema.
/// - VariantSuccess: A variante de sucesso do tema.
/// - VariantWarning: A variante de alerta do tema.
/// - VariantError: A variante de erro do tema.
/// - VariantInfo: A variante de info do tema.
pub type UIVariant {
  VariantAncestor(UIAncestor)
  VariantDefault
  VariantPrimary
  VariantSecondary
  VariantTertiary
  // As Semânticas (Feedback)
  VariantSuccess
  VariantWarning
  VariantError
  VariantInfo
}

/// Aparência de um elemento o seu estilo.
///
pub type UIAppearance {
  AppearanceAncestor(UIAncestor)
  AppearanceDefault
  /// Apresentam fundo de cor sólida, ideal para ações primárias devido à alta
  /// visibilidade.
  AppearanceFilled
  /// Combine uma ação primária padrão com uma seta suspensa que revela um menu
  /// de ações alternativas relacionadas
  AppearanceSlit
  /// Tenha um fundo transparente com borda e rótulo de texto. Eles são adequados
  /// para ações secundárias, pois são menos proeminentes visualmente do que
  /// a aparencia sólida.
  AppearanceGhost
  /// Ao sobrepor várias sombras desfocadas com cores brilhantes, você pode criar
  /// um efeito luminoso
  AppearanceLight
  /// Estilo que adiciona bordas, sombras e cantos arredondados e, em seguida,
  /// aplica suas próprias cores e preenchimento
  AppearanceFlat
  /// "fino" usando CSS, você pode ajustar suas dimensões usando padding, height.
  AppearanceThin
}

/// Estado de um elemento.
///
pub type UIState {
  StateAncestor(UIAncestor)
  /// Intocado ou parado (Padrão)
  StateIdle
  /// Passando ou ficando sobre
  StateHover
  /// Focado (a11y)
  StateFocus
  /// Sendo precionado
  StatePressed
  /// Aguardando sistema
  StateLoading
  /// Desligado ou não acessível
  StateDisabled
}

/// Formato da superfície de um elemento.
///
/// O "quão redondo" é o elemento não depende do tamanho
pub type UIShape {
  ShapeAncestor(UIAncestor)
  /// Quadrado perfeito (0px radius)
  ShapeSharp
  /// Arredondamento suave (Design Web Clássico)
  ShapeRounded(size: UISize, direction: UIDirection)
  /// Bordas totalmente arredondadas (Design iOS/Mobile)
  ShapePill
  /// Círculo perfeito (Para avatares e icon_only)
  ShapeCircle
}

/// Escala do tamanho de um elemento.
///
/// - Altura, Largura, Fonte e Espaçamento Interno (Padding).
///
pub type UISize {
  SizeAncestor(UIAncestor)
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
}

/// Como controlar o empilhamento dos elementos.
///
pub type UIStacking {
  StackAncestor(UIAncestor)
  /// - IndexXxs:  9
  StackXxs
  /// - IndexXs:   99
  StackXs
  /// - IndexSm:   999
  StackSm
  /// - IndexBase: 1
  StackBase
  /// - IndexLg:   9999
  StackLg
  /// - IndexXl:   99999
  StackXl
  /// - IndexXxl:  999999
  StackXxl
}

/// Como controlar a sensação de elevação dos elementos.
///
pub type UIElevation {
  ElevationAncestor(UIAncestor)
  /// Grudado no chão (Sem sombra)
  ElevationFlat
  /// Levemente levantado (Cards, Dropdowns sutis)
  ElevationLow
  /// Flutuando (Modais, Menus flutuantes)
  ElevationMedium
  /// Voando alto (Tooltips, Notificações Toast)
  ElevationHigh
  /// Afundado (Sombra interna, útil para inputs)
  ElevationInner
}

/// Direção de um elemento esquerda, direita, cima, baixo ou centro
///
pub type UIDirection {
  DirectionDefault
  DirectionAncestor(UIAncestor)
  DirectionX(UIHorizontal)
  DirectionY(UIVertical)
  DirectionXY(x: UIVertical, y: UIHorizontal)
}

///
///
pub type UIHorizontal {
  Left
  Right
  Central
}

///
///
pub type UIVertical {
  Top
  Bottom
  Middle
}

/// Como controlar a herança:
/// - initial: Define a propriedade para o valor padrão do CSS.
/// - inherit: Força o elemento a herdar o valor do elemento pai.
/// - all: inherit: Pode ser usado para forçar todas as propriedades a serem herdadas do pai
///
/// O padrão é recuperar o antecessor e se não encontrar recuperar as variantes padrões do
/// dispositivo em que estamos pintando o elemento utilizando o tema específico.
pub type UIAncestor {
  ///
  AncestorInitial
  AncestorInherit
  AncestorAll
}

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
pub fn paint(theme_builder: UIThemeBuilder(token)) -> List(token) {
  let UIThemeBuilder(theme:, builder:) = theme_builder
  let UITheme(
    variant:,
    appearance:,
    state:,
    stacking:,
    elevation:,
    size:,
    shape:,
    direction:,
  ) = theme
  let UIBuilder(
    base_to_tokens:,
    design_to_tokens:,
    stacking_to_tokens:,
    elevation_to_tokens:,
    size_to_tokens:,
    shape_to_tokens:,
    direction_to_tokens:,
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
  let direction =
    option.map(direction, direction_to_tokens)
    |> option.unwrap([])

  // O design é a parte mais importante do tema, pois é ele que define a aparência
  let designs = design_to_tokens(variant, appearance, state)

  engine.new(base)
  |> engine.with_size(sizes)
  |> engine.with_design(designs)
  |> engine.with_stacking(stackings)
  |> engine.with_elevation(elevations)
  |> engine.with_shape(shapes)
  |> engine.with_direction(direction)
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
  apply theme: UIThemeBuilder(token),
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
pub fn new() -> UIThemeBuilder(tokens) {
  UIThemeBuilder(theme: theme(), builder: builder())
}

///
pub fn with_variant(
  theme_builder: UIThemeBuilder(tokens),
  variant variant: UIVariant,
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, variant:),
  )
}

///
pub fn with_appearance(
  theme_builder: UIThemeBuilder(tokens),
  appearance appearance: UIAppearance,
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, appearance:),
  )
}

///
pub fn with_state(
  theme_builder: UIThemeBuilder(tokens),
  state state: UIState,
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(..theme_builder, theme: UITheme(..theme_builder.theme, state:))
}

///
pub fn with_design(
  theme_builder: UIThemeBuilder(tokens),
  variant variant: UIVariant,
  appearance appearance: UIAppearance,
  state state: UIState,
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, variant:, appearance:, state:),
  )
}

///
pub fn with_size(
  theme_builder: UIThemeBuilder(tokens),
  size size: Option(UISize),
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(..theme_builder, theme: UITheme(..theme_builder.theme, size:))
}

///
pub fn with_shape(
  theme_builder: UIThemeBuilder(tokens),
  shape shape: Option(UIShape),
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(..theme_builder, theme: UITheme(..theme_builder.theme, shape:))
}

///
pub fn with_elevation(
  theme_builder: UIThemeBuilder(tokens),
  elevation: Option(UIElevation),
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, elevation:),
  )
}

///
pub fn with_stacking(
  theme_builder: UIThemeBuilder(tokens),
  stacking stacking: Option(UIStacking),
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, stacking:),
  )
}

///
pub fn with_direction(
  theme_builder: UIThemeBuilder(tokens),
  direction direction: Option(UIDirection),
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, direction:),
  )
}

/// Remove o empilhamento do elemento.
///
pub fn without_stacking(
  theme_builder: UIThemeBuilder(tokens),
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, stacking: None),
  )
}

/// Remove a elevação do elemento
///
pub fn without_elevation(
  theme_builder: UIThemeBuilder(tokens),
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, elevation: None),
  )
}

/// Remove o tamanho de um elemento.
///
pub fn without_size(
  theme_builder: UIThemeBuilder(tokens),
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, size: None),
  )
}

/// Remove a superfície de um elemento
///
pub fn without_shape(
  theme_builder: UIThemeBuilder(tokens),
) -> UIThemeBuilder(tokens) {
  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, shape: None),
  )
}

/// Tamanho padrão, caso o tema não contenha um tamanho determinado.
///
pub fn with_size_default(
  theme_builder: UIThemeBuilder(token),
  size: UISize,
) -> UIThemeBuilder(token) {
  let size = option.unwrap(theme_builder.theme.size, size)

  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, size: Some(size)),
  )
}

/// Empilhamento padrão, caso o tema não contenha um determinado.
///
pub fn with_stacking_default(
  theme_builder: UIThemeBuilder(token),
  stacking: UIStacking,
) -> UIThemeBuilder(token) {
  let stacking = option.unwrap(theme_builder.theme.stacking, stacking)

  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, stacking: Some(stacking)),
  )
}

/// Elevação padrão, caso o tema não contenha um determinado.
///
pub fn with_elevation_default(
  theme_builder: UIThemeBuilder(token),
  elevation: UIElevation,
) -> UIThemeBuilder(token) {
  let elevation = option.unwrap(theme_builder.theme.elevation, elevation)

  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, elevation: Some(elevation)),
  )
}

/// Superfície padrão, caso o tema não contenha um determinado.
///
pub fn with_shape_default(
  theme_builder: UIThemeBuilder(token),
  shape: UIShape,
) -> UIThemeBuilder(token) {
  let shape = option.unwrap(theme_builder.theme.shape, shape)

  UIThemeBuilder(
    ..theme_builder,
    theme: UITheme(..theme_builder.theme, shape: Some(shape)),
  )
}

/// Converte para tokens iniciais, padrão, de estilização.
///
pub fn with_base_to_tokens(
  theme_builder: UIThemeBuilder(token),
  base_to_tokens: fn() -> List(token),
) -> UIThemeBuilder(token) {
  UIThemeBuilder(
    ..theme_builder,
    builder: UIBuilder(..theme_builder.builder, base_to_tokens:),
  )
}

/// Converte uma variante do tema em tokens.
///
pub fn with_design_to_tokens(
  theme_builder: UIThemeBuilder(token),
  design_to_tokens: fn(UIVariant, UIAppearance, UIState) -> List(token),
) -> UIThemeBuilder(token) {
  UIThemeBuilder(
    ..theme_builder,
    builder: UIBuilder(..theme_builder.builder, design_to_tokens:),
  )
}

/// Converte uma pilha visual do tema em tokens.
///
pub fn with_stacking_to_tokens(
  theme_builder: UIThemeBuilder(token),
  stacking_to_tokens: fn(UIStacking) -> List(token),
) -> UIThemeBuilder(token) {
  UIThemeBuilder(
    ..theme_builder,
    builder: UIBuilder(..theme_builder.builder, stacking_to_tokens:),
  )
}

/// Converte uma elevação do tema em tokens.
///
pub fn with_elevation_to_tokens(
  theme_builder: UIThemeBuilder(token),
  elevation_to_tokens: fn(UIElevation) -> List(token),
) -> UIThemeBuilder(token) {
  UIThemeBuilder(
    ..theme_builder,
    builder: UIBuilder(..theme_builder.builder, elevation_to_tokens:),
  )
}

/// Converte um tamanho do tema em tokens.
///
pub fn with_size_to_tokens(
  theme_builder: UIThemeBuilder(token),
  size_to_tokens: fn(UISize) -> List(token),
) -> UIThemeBuilder(token) {
  UIThemeBuilder(
    ..theme_builder,
    builder: UIBuilder(..theme_builder.builder, size_to_tokens:),
  )
}

/// Converte uma superfície visual do tema em tokens.
///
pub fn with_shape_to_tokens(
  theme_builder: UIThemeBuilder(token),
  shape_to_tokens: fn(UIShape) -> List(token),
) -> UIThemeBuilder(token) {
  UIThemeBuilder(
    ..theme_builder,
    builder: UIBuilder(..theme_builder.builder, shape_to_tokens:),
  )
}

// -----------------------------------------------------------------------------
//
// --- HELPER THEME
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
pub fn is_primary(variant: UIVariant) -> Bool {
  VariantPrimary == variant
}

///
pub fn is_not_primary(variant: UIVariant) -> Bool {
  !is_primary(variant)
}

///
pub fn filled() -> UIAppearance {
  AppearanceFilled
}

///
pub fn flat() -> UIAppearance {
  AppearanceFlat
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
pub fn slit() -> UIAppearance {
  AppearanceSlit
}

///
pub fn thin() -> UIAppearance {
  AppearanceThin
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
pub fn focus() -> UIState {
  StateFocus
}

///
pub fn hover() -> UIState {
  StateHover
}

///
pub fn loading() -> UIState {
  StateLoading
}

///
pub fn pressed() -> UIState {
  StatePressed
}

///
pub fn sharp() -> Option(UIShape) {
  ShapeSharp
  |> Some()
}

///
pub fn pill() -> Option(UIShape) {
  ShapePill
  |> Some()
}

///
pub fn circle() -> Option(UIShape) {
  ShapeCircle
  |> Some()
}

///
pub fn rounded_all(size: UISize) -> Option(UIShape) {
  ShapeRounded(size:, direction: DirectionDefault)
  |> Some()
}

///
pub fn rounded(size: UISize, direction: UIDirection) -> Option(UIShape) {
  ShapeRounded(size, direction)
  |> Some()
}

// -----------------------------------------------------------------------------
//
// -- **IMPLEMENTAÇÂO DO TEMA USANDO O LUSTRE**
//
// **Lustre + UIThemeBuilder**
//
// Utilizamos os design tokens do tema como uma estrutura de uma tupla
// `#(String, Bool)`, compatível com a assinatura da função `attribute.classes`
// do lustre.
//
// ```gleam
// import lustre/element as el
// import lustre/attribute as a
//
// pub fn to_element(
//   tokens: List(#(String, Bool)),
//   attributes: List(a.Attribute(msg)),
//   elements: List(el.Element(msg)),
//   to_lustre:
//     fn(List(a.Attribute(msg)), List(el.Element(msg)) -> el.Element(msg))
// ) {
//   let attributes = [a.classes(tokens), ..attributes]
//
//   to_lustre(attributes, elements)
// }
// ```
//
// A função acima é o coração deste módulo, ela converte a lista de tuplas,
// representando os design tokens (on/off) tailwindcss gerados pelo tema, em
// um atributo lustre `attribute.Attribute(msg)`, usando `attribute.classes`.
//
// Abaixo segue como o tema utiliza a injeção desta implementação
// (Lustre + Tailwindcss):
//
// ```gleam
// import lustre/attribute as a
// import lustre/element/html as h
//
// pub fn alert(text) {
//   // Estilos externos
//   let attributes = [ a.class("mb-2") ]
//
//   // O texto do alerta (inner)
//   let elements = [h.text(text)]
//
//   let to_alert = fn(theme) {
//     // Motor de design tokens para um elemento lustre
//     to_lustre(theme, attributes, elements, h.div)
//     |> theme.view(theme, _)
//   }
//
//   theme.new()
//   |> theme.with_design_to_tokens(design_classes)
//   |> theme.with_size_to_tokens(size_classes)
//   |> theme.with_shape_to_tokens(rounded_classes)
//   |> theme.with_elevation_to_tokens(border_classes)
//   |> theme.with_stacking_to_tokens(stack_classes)
//   |> theme.with_variant(theme.VariantPrimary)
//   |> theme.with_appearance(theme.AppearanceFill)
//   |> theme.with_state(theme.StateFocus)
//   |> theme.with_size(theme.SizeLg)
//   |> theme.with_shape(theme.ShapePill)
//   |> theme.with_elevation(theme.ElevationFlat)
//   |> theme.with_stacking(theme.StackXxl)
//   |> to_alert()
// }
// ```
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// -- 🛠️ ENGINE LUSTRE (DESIGN TOKEN)
//
// -----------------------------------------------------------------------------

/// Tipos que representam os design tokens convertidos para atributos lustre.
///
/// - Classes: Convertido para a.classes
/// - Styles: Convertido para a.styles
/// - Style: Convertido para a.style
/// - Class: Convertido para a.class
///
pub type UILustre {
  Classes(List(#(String, Bool)))
  Styles(List(#(String, String)))
  Style(String, String)
  Class(String)
}

/// Conversor dos design tokens para um elementos lustre.
///
/// - theme: Design tokens gerados a partir do tema + o construtor de temas.
/// - attributes: Atributos do elemento lustre.
/// - elements: Elementos internos, caso necessário.
/// - to_lustre: Construtor do elemento lustre.
///
pub fn to_lustre(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
  to_lustre: fn(List(a.Attribute(a)), List(element.Element(a))) ->
    element.Element(a),
) -> element.Element(a) {
  let engine_lustre = fn(token) {
    case token {
      Class(token) -> a.class(token)
      Classes(token) -> a.classes(token)
      Styles(token) -> a.styles(token)
      Style(key, value) -> a.style(key, value)
    }
  }
  view(theme, fn(tokens: List(UILustre)) {
    let attributes =
      list.map(tokens, engine_lustre)
      |> list.append(attributes)

    to_lustre(attributes, elements)
  })
}

// -----------------------------------------------------------------------------
//
// -- 🛠️ Componentes base
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// 🧱 COMPONENTES (Lustre + UITheme + UIBuilder)
//
// -----------------------------------------------------------------------------

pub fn div(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.div)
}

pub fn header(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.header)
}

pub fn main(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.main)
}

pub fn section(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.section)
}

pub fn footer(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.footer)
}

pub fn aside(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.aside)
}

pub fn nav(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.nav)
}

pub fn ul(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.ul)
}

pub fn li(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.li)
}

pub fn details(
  theme: UIThemeBuilder(UILustre),
  summary: element.Element(a),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  let elements = [summary, ..elements]

  to_lustre(theme, attributes, elements, h.details)
}

//
// -- Imagem
//

pub fn img(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, [], fn(a, _) { h.img(a) })
}

pub fn svg(
  theme: UIThemeBuilder(UILustre),
  with attributes: List(a.Attribute(a)),
  inner elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.svg)
}

//
// -- Tabela
//

pub fn table(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.table)
}

pub fn th(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.th)
}

pub fn tr(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.tr)
}

pub fn td(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.td)
}

//
// -- Input
//

pub fn input(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, [], fn(a, _) { h.input(a) })
}

pub fn select(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.select)
}

/// <select...><option .../></select>
pub fn option(
  theme: UIThemeBuilder(UILustre),
  label: String,
  attributes: List(a.Attribute(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, [], fn(a, _) { h.option(a, label) })
}

/// <textarea>...</textarea>
pub fn textarea(
  theme: UIThemeBuilder(UILustre),
  text: String,
  a: List(a.Attribute(a)),
) -> element.Element(a) {
  to_lustre(theme, a, [], fn(a, _) { h.textarea(a, text) })
}

pub fn button(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.button)
}

pub fn a(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.a)
}

pub fn h1(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.h1)
}

pub fn h2(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.h2)
}

pub fn h3(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.h3)
}

pub fn h4(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.h4)
}

pub fn h5(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.h5)
}

pub fn h6(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.h6)
}

pub fn p(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.p)
}

pub fn span(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.span)
}

pub fn pre(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.pre)
}

pub fn label(
  theme: UIThemeBuilder(UILustre),
  attributes: List(a.Attribute(a)),
  elements: List(element.Element(a)),
) -> element.Element(a) {
  to_lustre(theme, attributes, elements, h.label)
}

//
// --- HELPER
//

pub fn token_to_list(token) {
  [token]
}

//
// --- CRIAR TEMA E BUILDER PADRÃO (Interno)
//

/// **NOVO TEMA PADRÃO**
///
/// Contrutor de um tema UI.
///
fn theme() -> UITheme {
  UITheme(
    variant: VariantDefault,
    appearance: AppearanceDefault,
    state: StateIdle,
    stacking: None,
    elevation: None,
    size: None,
    shape: None,
    direction: None,
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
    design_to_tokens: engine.builder_design_tokens([]),
    stacking_to_tokens: engine.builder_theme_tokens([]),
    elevation_to_tokens: engine.builder_theme_tokens([]),
    size_to_tokens: engine.builder_theme_tokens([]),
    shape_to_tokens: engine.builder_theme_tokens([]),
    direction_to_tokens: engine.builder_theme_tokens([]),
  )
}

// **TEMA + BUILDER (DEFAULT)**
//
// -- Alias p/ os motores dos Tokens (Interno)
//

/// Para converter os tokens, iniciais, padrão de estilo.
///
type BaseToTokens(token) =
  fn() -> List(token)

/// Para converter o tamanho em tokens.
///
type SizeToTokens(token) =
  fn(UISize) -> List(token)

/// Para converter o formato da superfície em tokens
///
type ShapeToTokens(token) =
  fn(UIShape) -> List(token)

/// Para converter o empilhamento em tokens
///
type StackingToTokens(token) =
  fn(UIStacking) -> List(token)

/// Para converter a sensação de elevação em tokens
///
type ElevationToTokens(token) =
  fn(UIElevation) -> List(token)

/// Para converter a sensação de elevação em tokens
///
type DirectionToTokens(token) =
  fn(UIDirection) -> List(token)

/// Para converter o de design (variante x aparência x estado) em tokens.
///
type DesignToTokens(token) =
  fn(UIVariant, UIAppearance, UIState) -> List(token)
