////
//// 📥 UI Theme Input Module
////
//// Olá, neste módulo podemos encontrar a representação de um input.

import gleam/option.{type Option, None, Some}

import lustre/attribute as a
import lustre/element as el

import gbr/ui/theme

// -----------------------------------------------------------------------------
//
// -- Tipos
//
// -----------------------------------------------------------------------------

/// Dados do input.
///
/// - id: O identificador único do input.
/// - type_: O tipo de input.
///
pub type UIInput {
  UIInput(
    id: String,
    type_: UIInputType,
    value: Option(String),
    name: Option(String),
    required: Option(Bool),
  )
}

/// Criar novo input com id e tipo de texto (padrão).
///
/// - id: O identificador único do input.
///
pub fn new(id) {
  UIInput(id:, type_: Text, value: None, name: None, required: None)
}

/// Altera o tipo de input.
///
pub fn with_type(input, type_) {
  UIInput(..input, type_:)
}

/// Altera o nome do input.
///
pub fn with_name(input, name) {
  UIInput(..input, name: Some(name))
}

/// Altera o valor do input.
///
pub fn with_value(input, value) {
  UIInput(..input, value: Some(value))
}

/// Altera o valor para intocado, usado para limpar dados dos formulários.
///
pub fn without_value(input) {
  UIInput(..input, value: None)
}

/// O tipo de componente de input queremos representar
///
/// Inputs removidos e motivos:
///
/// ❌ InputButton (Use button.gleam)
/// ❌ InputSubmit (Use button.gleam com button.Submit)
/// ❌ InputImage (Obsoleto, use button com imagem dentro)
/// ❌ InputHidden (Se você precisa de um dado oculto, você apenas
/// guarda no Model). Não faz sentido tematizar um campo oculto.
///
pub type UIInputType {
  /// Um controle para inserir um número de telefone. Exibe um teclado telefônico
  /// em alguns dispositivos com teclados dinâmicos.
  Tel
  /// Um campo para editar um endereço de e-mail. Parece um campo de entrada de texto,
  /// mas possui parâmetros de validação e teclado compatível em navegadores e
  /// dispositivos com teclados dinâmicos.
  Email
  /// O valor padrão. Um campo de texto de linha única. As quebras de linha são
  /// removidas automaticamente do valor de entrada.
  Text
  /// Um campo de texto de linha única cujo valor está oculto. Alertará o usuário se
  /// o site não for seguro.
  Password
  /// ❌ InputCheckbox (Use checkbox.gleam focado em Bool)
  Checkbox
  /// ❌ InputRadio (Use radio.gleam focado em Bool/Enums)
  Radio
  /// Um campo para inserir um URL. Parece um campo de entrada de texto, mas possui
  /// parâmetros de validação e teclado compatível em navegadores e dispositivos
  /// com teclados dinâmicos.
  Url
  /// Um controle para especificar uma cor; abre um seletor de cores quando ativo
  /// em navegadores compatíveis.
  Color
  /// Um controle para inserir um número cujo valor exato não é importante. Exibe-se
  /// como um widget de intervalo, com o valor médio como padrão. Usado em conjunto
  /// com os controles min e max para definir o intervalo de valores aceitáveis.
  /// TODO: Range merecesse um slider customizado no futuro!
  Range
  /// Um controle para inserir um número. Exibe um indicador de seleção e adiciona
  /// validação padrão. Exibe um teclado numérico em alguns dispositivos com teclados
  /// dinâmicos.
  Number
  /// Um controle para inserir uma data (ano, mês e dia, sem hora). Abre um seletor
  /// de datas ou listas numéricas para ano, mês e dia quando ativo em navegadores
  /// compatíveis.
  Date
  /// Um controle para inserir um valor de tempo sem fuso horário.
  Time
  /// Um controle para inserir uma data composta por um número de semana-ano e um
  /// número de semana, sem fuso horário.
  Week
  /// Um campo para inserir o mês e o ano, sem fuso horário.
  Month
  /// Um controle para inserir data e hora, sem fuso horário. Abre um seletor
  /// de data ou listas numéricas para componentes de data e hora quando ativo em
  /// navegadores compatíveis.
  DateTimeLocal
  /// Um campo de texto de linha única para inserir termos de pesquisa. As
  /// quebras de linha são removidas automaticamente do valor de entrada.
  /// Pode incluir um ícone de exclusão em navegadores compatíveis, que pode ser
  /// usado para limpar o campo. Exibe um ícone de pesquisa em vez da tecla Enter
  /// em alguns dispositivos com teclados dinâmicos.
  Search
  /// Controle para inserir arquivos.
  File
}

/// Converte a representação de um input em um elemento lustre.
///
/// - id: Identificação do elemento input.
/// - type_: Tipo do elemento input.
/// - attributes: Atributos adicionais ao elemento input.
///
pub fn view(
  input: UIInput,
  theme: theme.UITheme(theme.UILustre),
  with attributes: List(a.Attribute(msg)),
) -> el.Element(msg) {
  let UIInput(id:, type_:, value:, name:, required:) = input

  let type_ = get_type(type_)
  let value =
    value
    |> option.map(a.value)
    |> option.unwrap(a.none())
  let name =
    name
    |> option.map(a.name)
    |> option.unwrap(a.none())
  let required =
    required
    |> option.map(a.required)
    |> option.unwrap(a.none())

  theme.input(theme, [a.id(id), type_, value, name, required, ..attributes])
}

//
// -- Auxiliares (Interno)
//

/// Lustre attribute a partir do tipo de input
fn get_type(type_) -> a.Attribute(msg) {
  case type_ {
    Tel -> "tel"
    Email -> "email"
    Text -> "text"
    Password -> "password"
    Url -> "url"
    Color -> "color"
    Range -> "range"
    Number -> "number"
    Date -> "date"
    Time -> "time"
    Week -> "week"
    Month -> "month"
    DateTimeLocal -> "datetime-local"
    Search -> "search"
    Checkbox -> "checkbox"
    Radio -> "radio"
    File -> "file"
  }
  |> a.type_()
}
