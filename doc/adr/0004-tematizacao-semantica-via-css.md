# ADR 0004: Tematização Semântica baseada em CSS/Tailwind Config

**Status:** Aceito

**Contexto:**
Para permitir que o pacote `gbr_ui_tailwindcss` atenda identidades visuais diferentes (Admin vs Landing Page), precisávamos evitar hardcodar cores literais (como `bg-blue-600`) nos componentes. Passar as cores dinamicamente via atributos para cada componente poluiria o código consumidor.

**Decisão:**
O motor de renderização `gbr_ui_tailwindcss` utilizará estritamente Classes Utilitárias Semânticas (ex: `bg-brand-500`, `text-content-muted`, `bg-danger-500`). A resolução dessas classes semânticas para cores HEX/RGB reais será responsabilidade exclusiva do consumidor final (`gbr_ui_admin`, `gbr_ui_landing`), implementada através da configuração do `tailwind.config.js` ou variáveis CSS globais no escopo do projeto.

**Consequências:**
* **Positivo:** Alcançamos um Design System totalmente "White-Label".
* **Positivo:** O código Gleam permanece limpo de lógicas de injeção de estilo.
* **Negativo:** Requer que o consumidor final mantenha e configure corretamente o arquivo de estilos/configuração do Tailwind para que a UI não "quebre" por falta de definição da cor semântica.
