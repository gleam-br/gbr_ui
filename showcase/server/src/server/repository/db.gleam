//// GBR: UI Showcase Database Mock em JSON
////
//// Tentativa de simular o retorno das consultas aos bancos de dados:
////
//// ## Atenção
//// > Funcionalidade depreciada por hora!
////
//// Agora iremos utilizar o `shared` para conectarmos diretamente na API , já
//// existente em Java. A ideia é termos um API Gateway, nosso novo servidor `server`.
////
//// **Vantagens**
//// Podemos realizar deploy no Cloudflare Worker na ponta (Edge), mas próximo
//// dos nossos clientes, possibilitando uma **latência** quase **zero**.
//// _Observação_: A latência zero vai funcionar para dados cacheados, dados que
//// necessitam ser consultados na base de dados, ainda teremos a mesma latência.
////
//// **Desvantagens**
//// Overhead de mais um pulo na rede, teremos nosso novo API Gateway repassando
//// as chamadas ao nosso servidor atual em Java, que serve APIs para manipular
//// os dados no bando de dado.
////

import storail

pub type AcessoRemotoSsp

pub type ApontamentoSsp

pub type AtendimentoPlainSsp

pub type BancoHoraPagamentoSsp

pub type HorasConsultorSsp

pub type ChamadoSsp

pub type ClienteSsp

pub type ConsultorSsp

pub type ProjetoSsp

pub type PropriedadeSsp

pub type ContatoSsp

pub type EmpresaSsp

pub type EntidadeSsp

pub type UsuarioSsp

pub type ValorPropriedadeSsp

pub type TiposProjetoSsp

pub type TipoMinutoSsp

pub type TipoAtendimentoSsp

pub type TipoValorPropriedadeSsp

pub type AtendimentoSobrepostoSsp

pub type ResumoAtendimentoSsp

pub type Platform

pub type Tech

pub type Host

pub type Property

pub type Version

pub type VersionClient

pub type ContentContent

pub type Db {
  Db(
    acessos: storail.Collection(AcessoRemotoSsp),
    apontamentos: storail.Collection(ApontamentoSsp),
    atendimentos: storail.Collection(AtendimentoPlainSsp),
    bancohoras: storail.Collection(BancoHoraPagamentoSsp),
    horas_consultor: storail.Collection(HorasConsultorSsp),
    chamados: storail.Collection(ChamadoSsp),
    clientes: storail.Collection(ClienteSsp),
    consultores: storail.Collection(ConsultorSsp),
    projetos: storail.Collection(ProjetoSsp),
    propriedades: storail.Collection(PropriedadeSsp),
    contatos: storail.Collection(ContatoSsp),
    empresas: storail.Collection(EmpresaSsp),
    entidades: storail.Collection(EntidadeSsp),
    usuarios: storail.Collection(UsuarioSsp),
    valor_propriedades: storail.Collection(ValorPropriedadeSsp),
    tipos_projeto: storail.Collection(TiposProjetoSsp),
    tipos_minutos: storail.Collection(TipoMinutoSsp),
    tipos_atendimento: storail.Collection(TipoAtendimentoSsp),
    tipos_valor_propriedades: storail.Collection(TipoValorPropriedadeSsp),
    atendimento_sobreposto: storail.Collection(AtendimentoSobrepostoSsp),
    atendimento_resumo: storail.Collection(ResumoAtendimentoSsp),
    plataformas: storail.Collection(Platform),
    tecnologias: storail.Collection(Tech),
    hosts: storail.Collection(Host),
    properties: storail.Collection(Property),
    version: storail.Collection(Version),
    version_client: storail.Collection(VersionClient),
    content_content: storail.Collection(ContentContent),
  )
  DbMock
}

pub fn new() {
  DbMock
  // shork.default_config()
  // |> shork.user("root")
  // |> shork.password("root")
  // |> shork.database("showcase")
  // |> shork.connect()
}
