# ADR 0001: Arquitetura Hexagonal (Ports & Adapters) para o Design System

**Status:** Aceito

**Contexto:**
Precisamos construir um Design System (`gbr_ui`) que seja escalável, puramente funcional e agnóstico de framework CSS. Inicialmente, o sistema usará TailwindCSS, mas no futuro poderá suportar Bootstrap ou CSS puro. Misturar a lógica matemática da UI (ADTs) com as classes literais do Tailwind em um único pacote criaria um acoplamento forte, impedindo a reutilização do core visual em diferentes contextos e frameworks.

**Decisão:**
Adotaremos uma arquitetura dividida em três camadas de pacotes:
1. `gbr_ui` (Core/Ontologia): Contém apenas Tipos Algébricos (ADTs) baseados no Lustre, definindo a física e propriedades da UI (ex: `UIVariant`, `UISize`), sem conhecimento de CSS.
2. `gbr_ui_tailwindcss` (Motor/Adapter): Consome o Core e traduz as ADTs em componentes Lustre com classes TailwindCSS (nossa Engine V8).
3. `gbr_ui_admin` / `gbr_ui_landing` (Consumidores/Palcos): Consomem a engine para montar templates, layouts e organismos específicos de cada produto.

**Consequências:**
* **Positivo:** Desacoplamento total. Podemos criar um `gbr_ui_bootstrap` no futuro sem alterar a lógica de negócios ou as ADTs base.
* **Positivo:** Projetos consumidores focam apenas em composição de layouts.
* **Negativo:** Aumenta a quantidade de pacotes a serem gerenciados e versionados no repositório.
