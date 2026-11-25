//// GBR: UI Theme Module — Vocabulário Visual e Design Token Algébrico.

import gleam/option.{type Option, None, Some}

import gbr/ui/theme/internal/engine

/// Dados para construir um tema a partir dos design tokens algébricos.
pub opaque type UITheme(tokens) {
  UITheme(painter: UIPainter, builder: UIBuilder(tokens))
}

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

type UIBuilder(token) {
  UIBuilder(
    base_to_tokens: fn() -> List(token),
    size_to_tokens: fn(UISize) -> List(token),
    shape_to_tokens: fn(UIShape) -> List(token),
    stacking_to_tokens: fn(UIStacking) -> List(token),
    elevation_to_tokens: fn(UIElevation) -> List(token),
    layout_to_tokens: fn(UILayout) -> List(token),
    design_to_tokens: fn(UIVariant, UIAppearance, UIState) -> List(token),
  )
}

/// Variante semântica de um elemento.
pub type UIVariant {
  VariantDefault
  VariantPrimary
  VariantSecondary
  VariantTertiary
  VariantSuccess
  VariantWarning
  VariantError
  VariantInfo
}

/// Aparência de um elemento.
pub type UIAppearance {
  AppearanceDefault
  AppearanceFilled
  AppearanceGhost
  AppearanceLight
  AppearanceOutline
}

/// Estado de um elemento.
pub type UIState {
  StateIdle
  StateLoading
  StateDisabled
  StatePressed
}

/// Formato da superfície de um elemento.
pub type UIShape {
  Shape(UISizeLayout)
  ShapeRounded
  ShapePill
  ShapeCircle
  ShapeSharp
}

/// Escala do tamanho de um elemento.
///
/// - Altura, Largura, Fonte e Espaçamento Interno (Padding).
///
pub type UISize {
  SizeXxl
  SizeXl
  SizeLg
  SizeMd
  SizeSm
  SizeXs
  SizeXxs
}

/// Controlar o empilhamento dos elementos no eixo Z.
pub type UIStacking {
  StackBase
  StackFloat
  StackSticky
  StackDropdown
  StackOverlay
  StackModal
  StackToast
  StackTooltip
}

/// Sensação de elevação (sombra) de um elemento.
pub type UIElevation {
  ElevationFlat(Option(UISizeLayout))
  ElevationInner(Option(UISizeLayout))
  ElevationThin(Option(UISizeLayout))
  ElevationLow(Option(UISizeLayout))
  ElevationMedium(Option(UISizeLayout))
  ElevationHigh(Option(UISizeLayout))
}

/// Estratégia de posicionamento no layout.
pub type UILayout {
  LayoutFlow(UIFlow)
  LayoutAbsolute(UIAbsolute)
}

/// Direção absoluta de um elemento.
pub type UIAbsolute {
  Axis(horizontal: UIAlignment, vertical: UIAlignment)
  AxisX(UIAlignment)
  AxisY(UIAlignment)
}

/// União de justify-content (main) e align-content/items (cross).
pub type UIFlow {
  Main(justify: UIAlignment)
  CrossItems(align: UIAlignment)
  CrossContent(align: UIAlignment)
  Flow(main: UIAlignment, cross_content: UIAlignment, cross_items: UIAlignment)
  FlowItems(main: UIAlignment, cross_items: UIAlignment)
  FlowContent(main: UIAlignment, cross_content: UIAlignment)
}

/// Opções de alinhamento em um eixo genérico.
pub type UIAlignment {
  Start
  End
  Center
  SpaceBetween
  SpaceAround
  SpaceEvenly
  Stretch
}

/// Tipo auxiliar para juntar tamanho e localização de um elemento visual.
///
pub type UISizeLayout =
  #(UISize, UILayout)

// -----------------------------------------------------------------------------
//
// -- Api
//
// -----------------------------------------------------------------------------

/// Converte o tema em tokens de design, utilizando o construtor de tokens.
pub fn paint(theme: UITheme(token)) -> List(token) {
  let UITheme(painter:, builder:) = theme

  engine.new(builder.base_to_tokens())
  |> engine.with_size(resolve_option(painter.size, builder.size_to_tokens))
  |> engine.with_shape(resolve_option(painter.shape, builder.shape_to_tokens))
  |> engine.with_design(builder.design_to_tokens(
    painter.variant,
    painter.appearance,
    painter.state,
  ))
  |> engine.with_stacking(resolve_option(
    painter.stacking,
    builder.stacking_to_tokens,
  ))
  |> engine.with_elevation(resolve_option(
    painter.elevation,
    builder.elevation_to_tokens,
  ))
  |> engine.with_positioning(resolve_option(
    painter.layout,
    builder.layout_to_tokens,
  ))
  |> engine.resolve()
}

fn resolve_option(
  value: Option(a),
  to_tokens: fn(a) -> List(token),
) -> List(token) {
  option.map(value, to_tokens)
  |> option.unwrap([])
}

/// Aplica o tema a um construtor de elemento visual genérico.
pub fn view(
  apply theme: UITheme(token),
  in to_element: fn(List(token)) -> a,
) -> a {
  to_element(paint(theme))
}

/// Cria novo tema e motor de elementos visuais estilizados.
pub fn new() -> UITheme(tokens) {
  UITheme(painter: painter(), builder: builder())
}

pub fn with_variant(
  theme: UITheme(tokens),
  variant variant: UIVariant,
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, variant:))
}

pub fn with_appearance(
  theme: UITheme(tokens),
  appearance appearance: UIAppearance,
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, appearance:))
}

pub fn with_state(
  theme: UITheme(tokens),
  state state: UIState,
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, state:))
}

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

pub fn with_size(
  theme: UITheme(tokens),
  size size: Option(UISize),
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, size:))
}

pub fn with_shape(
  theme: UITheme(tokens),
  shape shape: Option(UIShape),
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, shape:))
}

pub fn with_elevation(
  theme: UITheme(tokens),
  elevation: Option(UIElevation),
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, elevation:))
}

pub fn with_stacking(
  theme: UITheme(tokens),
  stacking stacking: Option(UIStacking),
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, stacking:))
}

pub fn with_layout(
  theme: UITheme(tokens),
  layout layout: Option(UILayout),
) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, layout:))
}

pub fn without_stacking(theme: UITheme(tokens)) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, stacking: None))
}

pub fn without_elevation(theme: UITheme(tokens)) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, elevation: None))
}

pub fn without_size(theme: UITheme(tokens)) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, size: None))
}

pub fn without_shape(theme: UITheme(tokens)) -> UITheme(tokens) {
  UITheme(..theme, painter: UIPainter(..theme.painter, shape: None))
}

pub fn with_size_default(
  theme: UITheme(token),
  size: UISize,
) -> UITheme(token) {
  let size = option.unwrap(theme.painter.size, size)

  UITheme(..theme, painter: UIPainter(..theme.painter, size: Some(size)))
}

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

pub fn with_shape_default(
  theme: UITheme(token),
  shape: UIShape,
) -> UITheme(token) {
  let shape = option.unwrap(theme.painter.shape, shape)

  UITheme(..theme, painter: UIPainter(..theme.painter, shape: Some(shape)))
}

pub fn with_base_to_tokens(
  theme: UITheme(token),
  base_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, base_to_tokens:))
}

pub fn with_design_to_tokens(
  theme: UITheme(token),
  design_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, design_to_tokens:))
}

pub fn with_stacking_to_tokens(
  theme: UITheme(token),
  stacking_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, stacking_to_tokens:))
}

pub fn with_elevation_to_tokens(
  theme: UITheme(token),
  elevation_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, elevation_to_tokens:))
}

pub fn with_size_to_tokens(
  theme: UITheme(token),
  size_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, size_to_tokens:))
}

pub fn with_shape_to_tokens(
  theme: UITheme(token),
  shape_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, shape_to_tokens:))
}

pub fn with_layout_to_tokens(
  theme: UITheme(token),
  layout_to_tokens,
) -> UITheme(token) {
  UITheme(..theme, builder: UIBuilder(..theme.builder, layout_to_tokens:))
}

pub fn primary() -> UIVariant {
  VariantPrimary
}

pub fn secondary() -> UIVariant {
  VariantSecondary
}

pub fn tertiary() -> UIVariant {
  VariantTertiary
}

pub fn info() -> UIVariant {
  VariantInfo
}

pub fn success() -> UIVariant {
  VariantSuccess
}

pub fn warning() -> UIVariant {
  VariantWarning
}

pub fn error() -> UIVariant {
  VariantError
}

pub fn filled() -> UIAppearance {
  AppearanceFilled
}

pub fn ghost() -> UIAppearance {
  AppearanceGhost
}

pub fn light() -> UIAppearance {
  AppearanceLight
}

pub fn idle() -> UIState {
  StateIdle
}

pub fn disabled() -> UIState {
  StateDisabled
}

pub fn pressed() -> UIState {
  StatePressed
}

pub fn loading() -> UIState {
  StateLoading
}

pub fn shape_sharp() -> UIShape {
  ShapeSharp
}

pub fn shape_pill() -> UIShape {
  ShapePill
}

pub fn shape_circle() -> UIShape {
  ShapeCircle
}

pub fn shape_rounded() -> UIShape {
  ShapeRounded
}

pub fn shape_rounded_all(size: UISize) -> UIShape {
  rounded_absolute(size, AxisX(Center))
}

pub fn rounded_absolute(size: UISize, absolute: UIAbsolute) -> UIShape {
  Shape(#(size, layout_absolute(absolute)))
}

pub fn layout_flow_main(main) {
  layout_flow(Main(main))
}

pub fn layout_flow_cross_items(main) {
  layout_flow(CrossItems(main))
}

pub fn layout_flow_cross_content(main) {
  layout_flow(CrossContent(main))
}

pub fn layout_flow_items(main, cross_items) {
  layout_flow(FlowItems(main:, cross_items:))
}

pub fn layout_flow_content(main, cross_content) {
  layout_flow(FlowContent(main:, cross_content:))
}

pub fn layout_flow(flow) {
  LayoutFlow(flow)
}

pub fn layout_absolute_axis(horizontal, vertical) {
  layout_absolute(Axis(horizontal:, vertical:))
}

pub fn layout_absolute(axis) {
  LayoutAbsolute(axis)
}

pub fn is_primary(variant: UIVariant) -> Bool {
  VariantPrimary == variant
}

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
