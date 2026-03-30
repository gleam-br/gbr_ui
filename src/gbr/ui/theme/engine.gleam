////
//// 🔩 UI core theme engine module
////
//// engine.theme - Interpretador obrigatório do nosso vocabulário.
//// > Princípio do Menor Privilégio (PoLP)
////
//// Olá meu amigo, aqui temos o módulo para trabalharmos com o nosso vocabulário
//// de componentes visuais, de forma segura e padronizada. Este módulo impede que
//// nós possamos desenvolver um novo componente na biblioteca e errar a orderm de
//// precedencia aplicada dos nossos estilos nos componentes entre outras coisas.
////
//// Asseguramos matematicamente que nosso vocabulário seja traduzido adequadamente
//// para outra linguagem, sem termos efeitos colaterais indesejados.
////
//// "Na FP tudo é um funil: Dados -> Interpretador -> Novo Estado/Visão"
////
//// 🏆🚪🔐

import gleam/list

/// DesingToken baseado em string e flat (on/off).
pub type Tokens =
  List(#(String, Bool))

/// 🔒🎨 Nossa representação do tema utilizado.
///
/// Aqui utilizamos o padrão da programação funcional chamado Padrão Interpretador
/// (Interpreter Pattern) ou Avaliação de AST. Aqui temos a linguagem própria da solução
/// o `UITheme`.
///
/// - Record + Interpreter (Programação Funcional)
///   - `engine.compose`: Esse é o nosso interpretador.
///
/// **A Estrutura de Gavetas**: Cada componente preenche apenas o que precisa.
///
/// TODO (Fase 2): Implementar o DesignTokens em vez de string typed
pub opaque type UITheme {
  UITheme(
    base: Tokens,
    size: Tokens,
    shape: Tokens,
    elevation: Tokens,
    stacking: Tokens,
    cosmetics: Tokens,
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
pub fn new(base: Tokens) {
  UITheme(
    base:,
    size: [],
    shape: [],
    elevation: [],
    stacking: [],
    cosmetics: [],
  )
}

pub fn with_size(theme: UITheme, size: Tokens) {
  UITheme(..theme, size:)
}

pub fn with_shape(theme: UITheme, shape: Tokens) {
  UITheme(..theme, shape:)
}

pub fn with_elevation(theme: UITheme, elevation: Tokens) {
  UITheme(..theme, elevation:)
}

pub fn with_stacking(theme: UITheme, stacking: Tokens) {
  UITheme(..theme, stacking:)
}

pub fn with_cosmetics(theme: UITheme, cosmetics: Tokens) {
  UITheme(..theme, cosmetics:)
}

/// Compõem o vocabulário em estilos visuais ordenados e padronizados p/ serem
/// utilizado e convertidos à interface desejada. Nesta função estamos convertendo
/// nosso DesignToken p/ a estrutura que nosso atual DesignToken baseado em
/// String Typed -> List(#(String, Bool)).
/// > Mesma assinatura dos argumentos em `lustre/attribute.classes(args)`
///
/// - theme.gleam: O vabulário semântico visual dos componentes da interface.
///
/// A BLINDAGEM (O Template Method)
pub fn resolve(theme: UITheme) -> Tokens {
  list.flatten([
    theme.base,
    theme.size,
    theme.shape,
    theme.elevation,
    theme.stacking,
    theme.cosmetics,
  ])
}
