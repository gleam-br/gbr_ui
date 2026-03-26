////
//// 🤺✨ UI core theme module
////
//// theme.gleam = Vocabulário de Componentes Visuais.
//// > Princípio da Responsabilidade Única (SRP)
////
//// Olá, como vai? Preparado para uma jornada ao mundo dos "Design System Algébricos"?
////
//// Aqui temos um módulo muito especial cheio de tipos algébricos para representarmos
//// matematicamente o mundo externo e como manipulamos o tema visual dos nossos
//// componentes.
////
//// Aqui iremos encontrar as variantes do tema, a aparência dos componentes, o estado
//// em que eles estão, seu tamanho, etc.
////
//// **A IDEIA: Que esta biblioteca e vocabulário sejam universais para
//// desenvolver UI**
////
//// ## Objetivos
////
//// - Ter o poder de utilizar o mesmo vocabulário para web, mobile, desktop, etc.
//// - Ter o poder de utilizar as mesmas funções `core` para web, mobile, etc.
//// - Ter o poder de transportar o estado da UI sem comprometer a experiência de
//// quem está visualizando os componentes no dispositivo.
//// - Ter tipos algébricos puros (ADT) que possibilitem desenvolver componentes
//// visuais e uma experiência rica para quem está visualizando no dispositivo.
////
//// ## Arquitetura: Type-Safe Styled Systems
////
//// **CVA (Class Variance Authority)**
////
//// - **UIVariant** (A Alma / Identidade): Responde à pergunta "Qual é o propósito
//// dessa peça na interface?". É a ação principal? É um aviso? É uma ação destrutiva?
//// A identidade não muda se o usuário mexer o mouse.
//// - **UIAppearance** (Filled, Ghost, Flat, Light) ela dita como a "tinta" da UIVariant
//// é aplicada no componente:
//// - **Filled**: Fundo pintado, texto branco/contraste.
//// - **Light** (ou Soft): Fundo bem clarinho, texto escuro.
//// - **Ghost**: Sem fundo, com borda. (Alguns chamam de Outlined).
//// - **Flat** (ou Clear): Sem fundo, sem borda, só o texto pintado.
//// - **UIState** (O Tempo / Interação): Responde à pergunta "O que o usuário (ou a rede)
//// está fazendo com essa peça AGORA?". Ele está com o mouse em cima? Ele clicou?
//// A rede está lenta e está carregando? O botão foi desativado?
////
//// 🏆 O "Dream Team" da UI Matemática (theme.gleam)
////
//// O `theme.gleam` se transformar em um motor gráfico capaz de descrever **QUALQUER**
//// componente de interface no planeta. Estrutura final nossa ontologia:
//// - A Herança: UIAncestor
//// - O Espaço (Geometria): UISize e UIShape
//// - A Alma (Semântica): UIVariant
//// - A Pintura (Material): UIAppearance
//// - A Luz e A Física: UIElevation e UIStacking
//// - A Posição: UIDirection
//// - O Tempo: UIState
////
//// Teremos 8 dimensões base para representarmos visualmente um componente na
//// interface do dispositivo.
////
//// A ordem mental (e no código) de construir um elemento do zero até a pintura final é esta:
////
//// Estrutura Base (Invisível): Display (flex, grid), alinhamento, transições (transition-all).
//// - Dimensão 1 - Size (Espaço): padding, height, text-size. (Cria a caixa de contorno).
//// - Dimensão 2 - Shape (Forma): border-radius. (Molda a caixa).
//// - Dimensão 3 - Elevation (Física): shadow, z-index. (Levanta a caixa).
//// - Dimensão 4 - Cosmetics (A Pintura): Esta é a fusão nuclear de Variant + Appearance + State.
////
//// Elas não podem ser calculadas separadamente. A Cor (Variant) depende do preenchimento
//// (Appearance) que reage ao mouse (State).
////
//// ## Regra da Propriedade do CSS
////
//// - O Componente é dono de si mesmo (Internal): Ele dita o seu próprio padding, background,
//// text-color e border-radius. O desenvolvedor é proibido de tentar alterar isso via a.class().
//// Se o usuário quer um botão menor, ele deve usar a ADT `theme.SizeSm`. Se a ADT não atende,
//// ele deve construir o botão dele do zero usando o seu componente headless.
//// - O Usuário é dono do espaço exterior (External & DOM): O Escape Hatch attributes serve
//// EXCLUSIVAMENTE para injetar:
////   - Margens: mt-4, mb-2 (porque um botão não sabe se ele está perto ou longe de outro elemento).
////   - Posicionamento: absolute, z-index.
////   - Metadados do DOM: id="meu-botao", aria-label, data-testid.
////   - Eventos extras: on_mouse_enter, on_blur.
////
//// ## 🔥 O Cálculo da Trindade (O Coração da Pintura)
////
//// A "Fusão Nuclear" da pintura acontece cruzando as 3 dimensões:
//// - UIVariant (Cor) x UIAppearance (Preenchimento) x UIState (tempo):
//// - Matemática: 9 (Variantes) * 8 (Aparências) * 7 (Estados)
////   - Total: 504 combinações visuais únicas!
////
//// ✨ A Mágica do Gleam: No Gleam, graças ao curinga (_), você não precisa escrever 504 blocos
//// de regras em CSS puro. Você mapeia apenas os 10 ou 15 caminhos felizes que o seu design aprova,
//// e usa o `_, _, _ -> fallback(...)` para devorar as outras combinações impossíveis/indesejadas
//// em uma linha só!
////
//// 🌌 O Cálculo do Universo (As 8 Dimensões)
////
//// Se nós pegarmos um único elemento genérico (como um div atômico) e permitirmos que o
//// desenvolvedor configure livremente as 8 dimensões, qual será o tamanho da nossa "Ontologia de UI"?
////
//// - Matemática: 9 * 8 * 7 * 7 * 5 * 6 * 8 * 6
////   - Total Exato: 5.080.320 de estados possíveis.
////
//// Mais de **5 MILHÕES** de formas de desenhar um componente! 🤯
////
////
//// ## Explicando o sufixo `Default` e `Ancestor`
////
//// Para todos tipos de tema, inclusive os (size, shape, elevation, stacking),
//// temos dois sufixos importantes `Ancestor` e `Default`, segue um exemplo
//// usando o `UIVariant`:
////
//// - O VariantAncestor (A Herança): Ele significa "Eu não tenho cor própria,
//// olhe para o meu pai e faça o que ele mandar (ou padrão do dispositivo)"
////  (no CSS, isso é o inherit ou o currentColor).
//// - O VariantDefault (O Reset/Neutro): Ele significa "Eu quero a cor padrão
//// original deste componente, não importa onde eu esteja".
////
//// ---
////
//// **The Ultimate Algebraic UI Theme**
////
//// **Seja bem-vindo** ao lado luminoso (Gleam) e da Força (Funcional) e comece
//// a rir do seu próprio "Gollum" OOP ("My precioussss/objectssss!" 💍🧟‍♂️) e vai
//// ser a melhor parte do meu dia! Eu garanto =)

/// Variante semântica, conhecido como tema, de um elemento.
///
/// - VariantAncestor: A variante que recupera as variantes do seu elemento pai
/// - VariantPrimary: A variante principal do tema.
/// - VariantSecondary: A variante secundaria do tema.
/// - VariantTertiary: A variante de fallback do tema.
pub type UIVariant {
  VariantDefault
  VariantAncestor
  VariantPrimary
  VariantSecondary
  VariantTertiary
  // As Semânticas (Feedback)
  // (ex: verde)
  VariantSuccess
  // (ex: amarelo)
  VariantWarning
  // (ex: vermelho)
  VariantError
  // (ex: azul)
  VariantInfo
}

/// Aparência de um elemento o seu estilo.
///
pub type UIAppearance {
  AppearanceDefault
  AppearanceAncestor
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
  StateAncestor
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

/// Como controlar o empilhamento dos elementos.
///
/// - IndexBase: 1
/// - IndexXxs:  9
/// - IndexXs:   99
/// - IndexSm:   999
/// - IndexLg:   9999
/// - IndexXl:   99999
/// - IndexXxl:  999999
pub type UIStacking {
  StackAncestor
  StackXxs
  StackXs
  StackSm
  StackBase
  StackLg
  StackXl
  StackXxl
}

/// Como controlar a sensação de elevação dos elementos.
///
pub type UIElevation {
  ElevationAncestor
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

/// Escala do tamanho de um elemento.
///
/// Definir Altura, Largura, Fonte e Espaçamento Interno (Padding).
///
pub type UISize {
  SizeAncestor
  SizeXxl
  SizeXl
  SizeLg
  SizeMd
  SizeSm
  SizeXs
}

/// o "quão redondo" é o elemento não depende do tamanho
pub type UIShape {
  ShapeAncestor
  // Quadrado perfeito (0px radius)
  ShapeSharp
  // Arredondamento suave (Design Web Clássico)
  ShapeRounded(size: UISize, direction: UIDirection)
  // Bordas totalmente arredondadas (Design iOS/Mobile)
  ShapePill
  // Círculo perfeito (Para avatares e icon_only)
  ShapeCircle
}

/// Direção de um elemento esquerda, direita, cima, baixo ou centro
///
pub type UIDirection {
  DirectionAncestor
  DirectionCentral
  DirectionLeft
  DirectionRight
  DirectionTop
  DirectionBottom
}

/// Como controlar a herança:
/// - initial: Define a propriedade para o valor padrão do CSS.
/// - inherit: Força o elemento a herdar o valor do elemento pai.
/// - all: inherit: Pode ser usado para forçar todas as propriedades a serem herdadas do pai
///
/// O padrão é recuperar o antecessor e se não encontrar recuperar as variantes padrões do
/// dispositivo em que estamos pintando o elemento utilizando o tema específico.
pub type UIAncestor {
  AncestorInitial
  AncestorInherit
  AncestorAll
}

// --- Theme getters
//

/// Recupera todas as variantes de um elemento
///
pub fn get_variants() {
  [
    VariantAncestor,
    VariantDefault,
    VariantPrimary,
    VariantSecondary,
    VariantTertiary,
    VariantInfo,
    VariantSuccess,
    VariantWarning,
    VariantError,
  ]
}

/// Recupera todas as aparencias de um elemento
///
pub fn get_aparrences() {
  [
    AppearanceAncestor,
    AppearanceDefault,
    AppearanceLight,
    AppearanceThin,
    AppearanceFlat,
    AppearanceGhost,
  ]
}

/// Recupera todos possíveis estados dos elementos.
///
pub fn get_states() {
  [
    StateAncestor,
    StateIdle,
    StateHover,
    StatePressed,
    StateLoading,
    StateDisabled,
  ]
}

/// Recupera toda a escala de tamanhos
///
pub fn get_sizes() {
  [SizeAncestor, SizeXxl, SizeXl, SizeLg, SizeMd, SizeSm, SizeXs]
}
