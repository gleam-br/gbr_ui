////
//// 📥 UI input module
////
//// Olá, neste módulo podemos encontrar a representação de um input.

import gleam/option.{type Option}

import lustre/attribute as a
import lustre/element as el
import lustre/element/html as h

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
  InputRange
  /// Um botão de opção, que permite selecionar um único valor dentre várias opções
  /// com o mesmo nome.
  InputRadio
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
  /// Um botão de pressão sem comportamento padrão, exibindo o valor do atributo
  /// `value`, que por padrão está vazio.
  InputButton
  /// Um botão que submete um formulário.
  InputSubmit
  /// Uma caixa de seleção que permite selecionar/desmarcar valores individuais.
  InputCheckbox
  /// Um controle que permite ao usuário selecionar um arquivo. Use o atributo
  /// accept para definir os tipos de arquivos que o controle pode selecionar.
  InputFile
  /// Um controle que não é exibido, mas cujo valor é enviado ao servidor.
  /// Há um exemplo na próxima coluna, mas está oculto!
  InputHidden
  /// Um botão gráfico de envio. Exibe uma imagem definida pelo atributo src.
  /// O atributo alt é exibido caso o atributo src da imagem esteja ausente.
  InputImage
  /// Um campo de texto de linha única para inserir termos de pesquisa. As
  /// quebras de linha são removidas automaticamente do valor de entrada.
  /// Pode incluir um ícone de exclusão em navegadores compatíveis, que pode ser
  /// usado para limpar o campo. Exibe um ícone de pesquisa em vez da tecla Enter
  /// em alguns dispositivos com teclados dinâmicos.
  InputSearch
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
    InputButton -> "button"
    InputCheckbox -> "checkbox"
    InputTel -> "tel"
    InputEmail -> "email"
    InputText -> "text"
    InputPassword -> "password"
    InputUrl -> "url"
    InputColor -> "color"
    InputRange -> "range"
    InputRadio -> "radio"
    InputNumber -> "number"
    InputDate -> "date"
    InputTime -> "time"
    InputWeek -> "week"
    InputMonth -> "month"
    InputDateTimeLocal -> "datetime-local"
    InputFile -> "file"
    InputHidden -> "hidden"
    InputImage -> "image"
    InputSubmit -> "submit"
    InputSearch -> "search"
  }
  |> a.type_()
}
