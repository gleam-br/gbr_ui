////
//// GBR: UI Showcase Server Router module
////

import gleam/http
import gleam/option.{None}

import wisp.{type Request, type Response}

import server/repository/acessos
import server/repository/apontamentos
import server/repository/atendimentos
import server/repository/atualizacoes
import server/repository/autenticacao
import server/repository/bancohoras
import server/repository/chamados
import server/repository/portifolio
import server/repository/projetos
import server/repository/propriedades
import server/web

/// Trata a requisição roteando p/ a devida funcionalidade
pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  // Web middleware insere configurações p/ o http
  use req <- web.middleware(req, ctx.priv)

  // O módulo de roteamento agora lida apenas com roteamento e encaminha para os
  // módulos de recursos para lidar com solicitações.
  case wisp.path_segments(req) {
    [] ->
      case req.method {
        http.Get -> serve_index(ctx.priv <> "/static")
        _ -> wisp.not_found()
      }
    //
    // --- Security
    // TODO precisa retornar um token válido
    //
    ["security", "login"] -> autenticacao.login(ctx, req)
    ["security", "login", "refresh", ..rest] ->
      autenticacao.refresh(ctx, req, rest)
    //
    // --- Geral: Portifólio
    //
    ["portfolio", "platforms"] ->
      case req.method {
        http.Get -> portifolio.plataformas(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["portfolio", "technologies"] ->
      case req.method {
        http.Get -> portifolio.tecnologias(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["portfolio", "clients"] ->
      case req.method {
        http.Get -> portifolio.customers(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["portfolio", "hosts"] ->
      case req.method {
        http.Get -> portifolio.hosts(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "portfolio", "tipos-suporte"] ->
      case req.method {
        http.Get -> portifolio.tipos_suporte(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "portfolio", "tipos-severidade"] ->
      case req.method {
        http.Get -> portifolio.tipos_severidade(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "portfolio", "consultores"] ->
      case req.method {
        http.Get -> portifolio.consultores(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "portfolio", "tipos-projeto"] ->
      case req.method {
        http.Get -> portifolio.projeto_tipos(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "portfolio", "status-projeto"] ->
      case req.method {
        http.Get -> portifolio.projeto_status(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "portfolio", "tecnologias"] ->
      case req.method {
        http.Get -> portifolio.tecnologias_ssp(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "portfolio", "clientes"] ->
      case req.method {
        http.Get -> portifolio.customers_ssp(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    //
    // --- Coletor: Propriedades
    //
    ["properties"] ->
      case req.method {
        http.Get -> propriedades.listar(ctx, req)
        http.Post -> propriedades.incluir(ctx, req)
        _ -> wisp.method_not_allowed([http.Get, http.Post])
      }
    ["properties", id] ->
      case req.method {
        http.Delete -> propriedades.excluir(ctx, id)
        _ -> wisp.method_not_allowed([http.Delete])
      }
    //
    // --- Coletor: Atualizações
    //
    ["versions"] ->
      case req.method {
        http.Get -> atualizacoes.listar(ctx, req)
        http.Post -> atualizacoes.incluir(ctx, req)
        _ -> wisp.method_not_allowed([http.Get, http.Post])
      }
    ["versions", "next"] ->
      case req.method {
        http.Get -> atualizacoes.next(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["contents"] ->
      case req.method {
        http.Get -> atualizacoes.contents(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["update", "download", platform, version] ->
      case req.method {
        http.Get -> atualizacoes.download(ctx, platform, version)
        _ -> wisp.method_not_allowed([http.Get])
      }
    //
    // --- Ponto: Apontamentos
    //
    ["ssp", "ponto"] ->
      case req.method {
        http.Post -> apontamentos.inserir(ctx, req)
        http.Get -> apontamentos.listar(ctx, req)
        _ -> wisp.method_not_allowed([http.Get, http.Post])
      }
    ["ssp", "ponto", id] ->
      case req.method {
        http.Put -> apontamentos.alterar(ctx, id, req)
        http.Delete -> apontamentos.excluir(ctx, id)
        _ -> wisp.method_not_allowed([http.Put, http.Delete])
      }
    //
    // --- Ponto: Banco de Horas
    //
    ["ssp", "banco-horas"] ->
      case req.method {
        http.Get -> bancohoras.listar(ctx, req)
        http.Post -> bancohoras.inserir(ctx, req)
        _ -> wisp.method_not_allowed([http.Post, http.Get])
      }
    ["ssp", "banco-horas", "consultores", consultor, "ultimo-pagamento"] ->
      case req.method {
        http.Get -> bancohoras.ultimo_pagamento(ctx, consultor)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "banco-horas", "consultores", consultor, "horas"] ->
      case req.method {
        http.Get -> bancohoras.horas(ctx, consultor)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "banco-horas", id, "cancelar"] ->
      case req.method {
        http.Post -> bancohoras.cancelar(ctx, id)
        _ -> wisp.method_not_allowed([http.Post])
      }
    //
    // --- SSP: Acessos
    //
    ["ssp", "acessos"] ->
      case req.method {
        http.Get -> acessos.listar(ctx, req)
        http.Post -> acessos.inserir(ctx, req)
        _ -> wisp.method_not_allowed([http.Post, http.Get])
      }
    ["ssp", "acessos", id] ->
      case req.method {
        http.Get -> acessos.recuperar(ctx, id)
        http.Put -> acessos.alterar(ctx, id, req)
        http.Delete -> acessos.excluir(ctx, id)
        _ -> wisp.method_not_allowed([http.Put, http.Delete, http.Get])
      }
    //
    // --- SSP: Atendimentos
    //
    ["ssp", "atendimentos"] ->
      case req.method {
        http.Get -> atendimentos.listar(ctx, req)
        http.Post -> atendimentos.inserir(ctx, req)
        _ -> wisp.method_not_allowed([http.Post, http.Get])
      }
    ["ssp", "atendimentos", "minutos"] ->
      case req.method {
        http.Get -> atendimentos.minutos(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "atendimentos", "sobrepostos"] ->
      case req.method {
        http.Get -> atendimentos.sobrepostos(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "atendimentos", "tipos"] ->
      case req.method {
        http.Get -> atendimentos.tipos(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "atendimentos", id] ->
      case req.method {
        http.Put -> atendimentos.alterar(ctx, id, req)
        http.Delete -> atendimentos.excluir(ctx, id)
        _ ->
          wisp.method_not_allowed([
            http.Put,
            http.Delete,
          ])
      }
    //
    // --- SSP: Chamados
    //
    ["ssp", "chamados"] ->
      case req.method {
        http.Get -> chamados.listar(ctx, req)
        http.Post -> chamados.inserir(ctx, req)
        _ -> wisp.method_not_allowed([http.Get, http.Post])
      }
    ["ssp", "chamados", "tipos"] ->
      case req.method {
        http.Get -> chamados.tipos(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "chamados", id] ->
      case req.method {
        http.Get -> chamados.recuperar(ctx, id)
        http.Put -> chamados.alterar(ctx, id, req)
        http.Delete -> chamados.excluir(ctx, id)
        _ ->
          wisp.method_not_allowed([
            http.Get,
            http.Put,
            http.Delete,
          ])
      }
    ["ssp", "chamados", id, "meu"] ->
      case req.method {
        http.Patch -> chamados.meu(ctx, id)
        _ -> wisp.method_not_allowed([http.Patch])
      }
    ["ssp", "chamados", id, "resumo"] ->
      case req.method {
        http.Get -> chamados.resumo(ctx, id)
        _ -> wisp.method_not_allowed([http.Get])
      }
    //
    // --- SSP: Projetos
    //
    ["ssp", "projetos"] ->
      case req.method {
        http.Get -> projetos.listar(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "projetos", "incompletos"] ->
      case req.method {
        http.Get -> projetos.incompletos(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "projetos", "propriedades"] ->
      case req.method {
        http.Get -> projetos.propriedades(ctx, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "projetos", id, "propriedades"] ->
      case req.method {
        http.Get -> projetos.propriedades_por_id(ctx, id, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "projetos", id, "contatos"] ->
      case req.method {
        http.Get -> projetos.contatos(ctx, id, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "projetos", id, "tecnologias"] ->
      case req.method {
        http.Get -> projetos.tecnologias(ctx, id, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "projetos", id, "contrato"] ->
      case req.method {
        http.Get -> projetos.contrato(ctx, id, req)
        _ -> wisp.method_not_allowed([http.Get])
      }
    ["ssp", "projetos", id] ->
      case req.method {
        http.Get -> projetos.recuperar(ctx, id, req)
        http.Put -> projetos.alterar(ctx, id, req)
        _ -> wisp.method_not_allowed([http.Get, http.Put])
      }
    _ -> wisp.not_found()
  }
}

fn serve_index(priv) {
  wisp.ok()
  |> wisp.set_header("content-type", "text/html")
  |> wisp.set_body(wisp.File(
    path: priv <> "/index.html",
    offset: 0,
    limit: None,
  ))
}
