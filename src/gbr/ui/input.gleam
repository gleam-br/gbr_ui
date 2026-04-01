////
//// 📥 UI core input module
////
//// Olá, neste módulo podemos encontrar a representação de um input.

import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

import gbr/ui/theme

/// O tipo de componente de input queremos representar
pub type UIInputType {
  /// Um controle para inserir um número de telefone. Exibe um teclado telefônico
  /// em alguns dispositivos com teclados dinâmicos.
  InputTel
  /// Um campo para editar um endereço de e-mail. Parece um campo de entrada de texto,
  /// mas possui parâmetros de validação e teclado compatível em navegadores e
  /// dispositivos com teclados dinâmicos.
  InputEmail
  /// O valor padrão. Um campo de texto de linha única. As quebras de linha são
  /// removidas automaticamente do valor de entrada.
  InputText
  /// Um campo de texto de linha única cujo valor está oculto. Alertará o usuário se
  /// o site não for seguro.
  InputPassword
  /// Um campo para inserir um URL. Parece um campo de entrada de texto, mas possui
  /// parâmetros de validação e teclado compatível em navegadores e dispositivos
  /// com teclados dinâmicos.
  InputUrl
  /// Um controle para especificar uma cor; abre um seletor de cores quando ativo
  /// em navegadores compatíveis.
  InputColor
  /// Um controle para inserir um número cujo valor exato não é importante. Exibe-se
  /// como um widget de intervalo, com o valor médio como padrão. Usado em conjunto
  /// com os controles min e max para definir o intervalo de valores aceitáveis.
  /// TODO: Range merecesse um slider customizado no futuro!
  InputRange
  /// Um controle para inserir um número. Exibe um indicador de seleção e adiciona
  /// validação padrão. Exibe um teclado numérico em alguns dispositivos com teclados
  /// dinâmicos.
  InputNumber
  /// Um controle para inserir uma data (ano, mês e dia, sem hora). Abre um seletor
  /// de datas ou listas numéricas para ano, mês e dia quando ativo em navegadores
  /// compatíveis.
  InputDate
  /// Um controle para inserir um valor de tempo sem fuso horário.
  InputTime
  /// Um controle para inserir uma data composta por um número de semana-ano e um
  /// número de semana, sem fuso horário.
  InputWeek
  /// Um campo para inserir o mês e o ano, sem fuso horário.
  InputMonth
  /// Um controle para inserir data e hora, sem fuso horário. Abre um seletor
  /// de data ou listas numéricas para componentes de data e hora quando ativo em
  /// navegadores compatíveis.
  InputDateTimeLocal
  /// Um campo de texto de linha única para inserir termos de pesquisa. As
  /// quebras de linha são removidas automaticamente do valor de entrada.
  /// Pode incluir um ícone de exclusão em navegadores compatíveis, que pode ser
  /// usado para limpar o campo. Exibe um ícone de pesquisa em vez da tecla Enter
  /// em alguns dispositivos com teclados dinâmicos.
  InputSearch
  // ❌ InputButton (Use button.gleam)
  // ❌ InputSubmit (Use button.gleam com button.ButtonSubmit)
  // ❌ InputImage (Obsoleto, use button com imagem dentro)
  // ❌ InputCheckbox (Use checkbox.gleam que já tem o estado Booleano)
  // ❌ InputRadio (Use radio.gleam focado em Booleanos/Enums)
  // ❌ InputHidden (No Lustre, se você precisa de um dado oculto, você apenas
  // guarda no Model.
}

/// O tipo que representa a nota de rodapé p/ o input.
///
/// - NoteInfo: Texto no estilo informativo.
/// - NoteSuccess: Texto no estilo de sucesso.
/// - NoteError: Texto no estilo de error.
/// - NoteWarn: Texto no estilo de alerta.
pub type UIInputNote {
  NoteInfo(text: String)
  NoteSuccess(text: String)
  NoteError(text: String)
  NoteWarn(text: String)
}

/// O tipo para representar um input administrativo.
///
/// - id: Identificador html, necessário.
/// - value: Valor do input opicional, quando `None` o input não foi tocado.
/// - label: Valor do label opicional, segue o atribute `a.for(input.id)`.
/// - note: Nota de rodapé opicional p/ o input.
pub type UIInput {
  UIInput(
    id: String,
    // `None` p/ um input intocado ainda, Some("") já foi digitado e apagado.
    // Evitamos mostrar erros de validação de input vazio ao carregar a página.
    value: Option(String),
    label: Option(String),
    note: Option(UIInputNote),
    placeholder: Option(String),
  )
}

/// Converte a nota do input p/ a variant correta do tema
pub fn note_to_variant(note) {
  case note {
    NoteInfo(_) -> theme.VariantInfo
    NoteSuccess(_) -> theme.VariantSuccess
    NoteError(_) -> theme.VariantError
    NoteWarn(_) -> theme.VariantWarning
  }
}

/// Converte a representação de um input em um elemento lustre.
@internal
pub fn to_element(
  id: String,
  type_: UIInputType,
  value value: Option(String),
  attributes attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  let type_ = get_type_(type_)
  let value =
    value
    |> option.map(a.value)
    |> option.unwrap(a.none())

  h.input([a.id(id), type_, value, ..attributes])
}

// PRIVATE
//

fn get_type_(type_) {
  case type_ {
    InputTel -> "tel"
    InputEmail -> "email"
    InputText -> "text"
    InputPassword -> "password"
    InputUrl -> "url"
    InputColor -> "color"
    InputRange -> "range"
    InputNumber -> "number"
    InputDate -> "date"
    InputTime -> "time"
    InputWeek -> "week"
    InputMonth -> "month"
    InputDateTimeLocal -> "datetime-local"
    InputSearch -> "search"
  }
  |> a.type_()
}

/// Criar um novo tipo que representa um input pelo identificador
///
/// - id: Identificador html.
pub fn new(id: String) {
  UIInput(id:, value: None, label: None, note: None, placeholder: None)
}

/// Incluir o valor ao input
///
/// - value: Valor do input.
pub fn with_value(input: UIInput, value: String) -> UIInput {
  UIInput(..input, value: Some(value))
}

/// Incluir um label ao input
///
/// - label: Label p/ este input.
pub fn with_label(input: UIInput, label: String) -> UIInput {
  UIInput(..input, label: Some(label))
}

/// Incluir um placeholder ao input
///
/// - label: Placeholder p/ este input.
pub fn with_placeholder(input: UIInput, placeholder: String) -> UIInput {
  UIInput(..input, placeholder: Some(placeholder))
}

/// Incluir uma nota de rodapé ao input.
///
/// - note: A nota de rodapé, ver funções: `note`,`note_info`, etc.
pub fn with_note(input: UIInput, note: UIInputNote) -> UIInput {
  UIInput(..input, note: Some(note))
}

pub fn without_note(input: UIInput) -> UIInput {
  UIInput(..input, note: None)
}

/// Criar uma nota de rodapé informativo.
pub fn note(text: String) -> UIInputNote {
  NoteInfo(text:)
}

/// Criar uma nota de rodapé de sucesso.
pub fn note_success(text: String) -> UIInputNote {
  NoteSuccess(text:)
}

/// Criar uma nota de rodapé de alerta.
pub fn note_warn(text: String) -> UIInputNote {
  NoteWarn(text:)
}

/// Criar uma nota de rodapé de erro.
pub fn note_error(text: String) -> UIInputNote {
  NoteError(text:)
}
