# ADR 0003: Roteamento Funcional Estrito (MVU Modular) sobre Dicionários OOP

**Status:** Aceito

**Contexto:**
A navegação do painel administrativo estava sendo controlada por um Padrão Strategy rudimentar, onde as funções de `view` e `init` das páginas eram armazenadas em Records do Gleam e buscadas via Dicionário usando a String da URL. Isso gerava estado impuro (funções no Model), falhas silenciosas (Stringly Typed) e dificuldade de debugar o fluxo MVU.

**Decisão:**
Substituir o dicionário de rotas por Roteamento Funcional Baseado em Tipos (Pattern Matching).
1. Uma ADT `Page` define estaticamente todas as rotas válidas.
2. O `Model` global achata o estado, guardando os sub-modelos das páginas filhas.
3. O `Update` e a `View` principais usam `e.map` e `el.map` para envelopar e delegar as mensagens (`Msg`) e efeitos locais de cada página isolada, mantendo os filhos ignorantes sobre a existência do pai.

**Consequências:**
* **Positivo:** Segurança em tempo de compilação (exhaustiveness checking no `case`).
* **Positivo:** O Model volta a ser um dado puro e serializável (Time-Travel Debugging amigável).
* **Positivo:** Isolamento perfeito entre as páginas (Componentização MVU real).
* **Negativo:** O arquivo `admin.gleam` (Pai) crescerá proporcionalmente ao número de páginas, pois precisará mapear cada mensagem delegada.
