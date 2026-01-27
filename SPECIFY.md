# Specify

Este projeto é uma biblioteca de componentes visuais que utilza o framework web [lustre](https://lustre.build).

A ideia é criar componentes base e complexos utlizando todo ferramental disponível no framework lustre. Temos dentro do diretório `src` a estrutura:

- gbr/ui: Aqui devem conter somente elementos visuais sem estilização visual, somente funções que possibilitem a configuração de class, style, etc. Assim teremos componentes seguindo o padrão da biblioteca [radix-ui](https://github.com/radix-ui).
- gbr/ui/admin: Aqui são componentes visuais que seguem a mesma estilização da biblioteca [tailadmin](https://github.com/TailAdmin). Portanto, são componentes visuais com estrutura e estilo próprio de design ui.
- gbr/ui/core: Este diretório armazena coisas internas e de uso geral, talvez devemos alterar o diretório para `internal`, devemos analisar a melhor estrutura aqui.
- gbr/ui/svg: Algumas implementações de svg utilizando o lustre svg, devemos encontrar a melhor forma de estruturar estes arquivos, inicialmente foi colocado aqui.

## Roadmap

- [ ] Analisar componentes em gbr/ui/admin que podem se tornar componentes somente gbr/ui sem estilização, somente com funções para configurar o estilo do componente.
- [ ] Refatorar os componentes, encontrados no passo anterior, em gbr/ui/admin, criando componentes em gbr/ui e reutilizando eles em gbr/ui/admin, tendo assim componentes abstratos de estilo em gbr/ui e os componentes com estilo de visualização igual ao tailadmin em gb/ui/admin.
