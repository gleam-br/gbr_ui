# Contexto de Desenvolvimento: gbr_ui
Este repositório contém os componentes visuais da fundação Gleam-BR.

## Premissas Técnicas
- Framework: Lustre (Gleam).
- Estilo: TailwindCSS.
- Target: JavaScript (Web Components / SPA).
- Filosofia: Componentes puros, orientados a mensagens, altamente customizáveis via propriedades.

## Padrões de Código
- Sempre prefira Types sobre Strings para estados de componentes.
- Utilize a interoperabilidade via `gbr_js` para manipulação de DOM específica se necessário.
- Mantenha a compatibilidade com o modelo de mensagens do N2O-Gleam.

# Contexto Técnico: gbr_ui
Biblioteca de componentes visuais baseada em Lustre.

## Princípios de Design
- **Composabilidade:** Componentes não devem gerenciar estado global. Eles recebem dados e emitem mensagens (Lustre Model/Msg).
- **Tailwind Nativo:** Todos os componentes utilizam utilitários Tailwind. Não crie CSS customizado a menos que estritamente necessário para Web Components.
- **Interoperabilidade:** Utilize `gbr_js` para integrações com APIs de Browser (ex: Intersection Observer) que o Lustre ainda não abstrai.

## Exemplo de Padrão
Sempre defina componentes seguindo a estrutura:
1. Types (Props/State)
2. View Function
3. Internal Helpers

# Contexto: gbr_ui
Biblioteca de componentes visuais utilizando Lustre + Tailwind.

## Diretrizes para o Gemini CLI:
1. **Estilo:** Use exclusivamente classes Tailwind via atributos Lustre.
2. **Web Components:** Foque na criação de componentes isolados que possam ser orquestrados pelo futuro BPM.
3. **Dependências:** Utilize `gbr_shared` para tipos de dados e `gbr_js` para manipulação de eventos de browser não cobertos pelo Lustre.

# Contexto: gbr_ui
Biblioteca de componentes visuais baseada em Lustre e TailwindCSS.

## Regras de Ouro para o Gemini:
1. **Arquitetura Lustre:** Componentes devem ser funções puras que retornam `Element(msg)`. Evite gerenciar estado complexo dentro do componente; prefira passar o estado via Props.
2. **Tailwind:** Utilize as funções do pacote `lustre/attribute` para aplicar classes Tailwind. Mantenha o design limpo e minimalista (estilo Journal).
3. **Acessibilidade:** Garanta que os componentes sigam boas práticas de ARIA, especialmente ao usar Shadow DOM.
4. **Modularidade:** Prepare os componentes para serem "cascas" que o BPM poderá preencher dinamicamente.
