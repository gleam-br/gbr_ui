////
//// UI core theme engine module
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
pub type UITheme {
  UITheme(
    base: List(#(String, Bool)),
    size: List(#(String, Bool)),
    shape: List(#(String, Bool)),
    elevation: List(#(String, Bool)),
    stacking: List(#(String, Bool)),
    cosmetics: List(#(String, Bool)),
  )
}

/// Compõem o vocabulário em estilos visuais ordenados e padronizados p/ serem
/// utilizado e convertidos à interface desejada.
///
/// - theme: O vabulário semântico visual dos componentes da interface.
///
/// A BLINDAGEM (O Template Method)
pub fn compose(theme: UITheme) -> List(#(String, Bool)) {
  list.flatten([
    theme.base,
    theme.size,
    theme.shape,
    theme.elevation,
    theme.stacking,
    theme.cosmetics,
  ])
}
