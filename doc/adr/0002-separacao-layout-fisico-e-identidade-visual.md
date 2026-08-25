# ADR 0002: Separação Estrita entre Layout Físico e Identidade Visual (App Shell)

**Status:** Aceito

**Contexto:**
Durante a criação de layouts, notou-se a tendência de incluir classes de cor (ex: `bg-white`, `dark:bg-gray-900`) dentro de funções estruturais genéricas (`flex-col`, `w-full`). Isso engessava o layout, impedindo que o mesmo fosse usado em contextos com fundos diferentes (ex: uma Landing Page vs. um Dashboard).

**Decisão:**
A responsabilidade do Layout será dividida em dois domínios:
1. `core/layout.gleam`: Lida EXCLUSIVAMENTE com a geometria (Física). Funções como `row`, `col`, `grid`, `center` não possuem cores, bordas ou sombras.
2. `admin/layout.gleam` (App Shells): Lida com a "Fonte da Verdade" da marca. Funções como `app_shell` e `split_screen` herdam a geometria e chumbarão as cores de fundo (Canvas) do projeto específico.

**Consequências:**
* **Positivo:** Funções geométricas tornam-se 100% reutilizáveis em qualquer projeto (Admin, Blog, Landing Page).
* **Positivo:** A identidade visual (cores globais) fica centralizada em um único "Singleton Visual" por aplicação.
* **Negativo:** Exige disciplina do desenvolvedor para não usar o escape hatch de `attributes` para injetar cores em layouts core.
