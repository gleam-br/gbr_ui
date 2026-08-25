////
//// 🔩 🎨 GBR: UI Theme Engine Module
////
//// - `engine.gleam:` Interpretador obrigatório do nosso vocabulário.
//// - `theme.gleam:` Vocabulário semântico visual dos componentes da interface.
////
//// Olá meu amigo, aqui temos o módulo para trabalharmos com o nosso vocabulário
//// de componentes visuais, de forma segura e padronizada. Este módulo impede que
//// nós possamos desenvolver um novo componente na biblioteca e errar a orderm de
//// precedencia aplicada dos nossos estilos nos componentes entre outras coisas.
////
//// Asseguramos matematicamente que nosso vocabulário seja traduzido adequadamente
//// para outra linguagem, sem termos efeitos colaterais indesejados.
////
//// 🏆🚪🔐
////

import gleam/list

/// 🎨 Lista de design tokens.
///
/// - token: Tipo fantasma representando um design token.
///
pub type Tokens(token) =
  List(token)

/// 🔒 Nossa representação do tema utilizado.
///
/// Aqui utilizamos o padrão da programação funcional chamado Padrão
/// Interpretador (Interpreter Pattern) ou Avaliação de AST. Aqui temos a
/// linguagem própria da solução.
///
/// - Model + Interpreter
///   - `engine.compose`: Esse é o nosso interpretador.
///
/// **A Estrutura**: Cada componente preenche apenas o que precisa.
///
/// - base: Tokens da base do estilo.
/// - design: Tokens semânticos, de aparência e estado.
/// - size: Tokens de tamanho.
/// - shape: Tokens de superfície.
/// - elevation: Tokens de elevação.
/// - stacking: Tokens de empilhamento.
/// - direction: Tokens de direção.
///
pub opaque type UIEngine(token) {
  UIEngine(
    base: Tokens(token),
    design: Tokens(token),
    size: Tokens(token),
    shape: Tokens(token),
    elevation: Tokens(token),
    stacking: Tokens(token),
    positioning: Tokens(token),
  )
}

/// Criar uma nova representação do tema.
///
/// Veja mais sobre em `core/theme.gleam`.
///
/// - base: Atributos da base do componente visual.
/// - size: Atributos de tamanho do componente visual.
/// - shape: Atributos do formato do componente visual.
/// - elevation: Atributos da sensação de elevação do componente visual.
/// - stacking: Atributes do empilhamento do componente visual.
/// - cosmetics: Atributes do estilo visual do componente.
pub fn new(base: Tokens(token)) {
  UIEngine(
    base:,
    design: [],
    size: [],
    shape: [],
    elevation: [],
    stacking: [],
    positioning: [],
  )
}

///
pub fn with_size(engine: UIEngine(token), size: Tokens(token)) {
  UIEngine(..engine, size:)
}

pub fn with_shape(engine: UIEngine(token), shape: Tokens(token)) {
  UIEngine(..engine, shape:)
}

pub fn with_elevation(engine: UIEngine(token), elevation: Tokens(token)) {
  UIEngine(..engine, elevation:)
}

pub fn with_stacking(engine: UIEngine(token), stacking: Tokens(token)) {
  UIEngine(..engine, stacking:)
}

pub fn with_design(engine: UIEngine(token), design: Tokens(token)) {
  UIEngine(..engine, design:)
}

pub fn with_positioning(engine: UIEngine(token), positioning: Tokens(token)) {
  UIEngine(..engine, positioning: positioning)
}

/// Compõem o vocabulário em estilos visuais ordenados e padronizados p/ serem
/// utilizado e convertidos à interface desejada. Nesta função estamos convertendo
/// nosso DesignToken p/ a estrutura que nosso atual DesignToken baseado em
/// String Typed -> List(#(String, Bool)).
/// > Mesma assinatura dos argumentos em `lustre/attribute.classes(args)`
///
/// A BLINDAGEM (O Template Method)
pub fn resolve(engine: UIEngine(token)) -> Tokens(token) {
  let UIEngine(
    base:,
    design:,
    size:,
    shape:,
    elevation:,
    stacking:,
    positioning:,
  ) = engine

  list.flatten([
    base,
    positioning,
    size,
    shape,
    elevation,
    stacking,
    design,
  ])
}
