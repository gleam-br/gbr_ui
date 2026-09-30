# 📺 GBR: UI Showcase

Este pacote atua como a aplicação visual e vitrine de todo o nosso Design System. Ele utiliza o [Vite](https://vite.dev) e o [Storybook](https://storybook.js.org/) para renderizar os componentes desenvolvidos na biblioteca `core`.

## 🚀 Rodando o Showcase e o Storybook

Este pacote consolida as bibliotecas `gbr_ui_storybook` e `gbr_ui` (Core) provendo uma interface interativa para ver os componentes em ação.

```bash
# 1. Instale as dependências do Node.js (Vite, Tailwind, Storybook)
npm install

# 2. Inicie o painel do Storybook
npm run storybook
```

O servidor abrirá automaticamente no seu navegador padrão (geralmente em `http://localhost:6006`), listando todos os componentes da UI, suas variantes (CVA), e opções para testes visuais integrados.

## 🛠 Comandos

- `npm run storybook`: Roda o servidor local.
- `npm run build`: Faz o build de produção do Vite.
- `npm run build-storybook`: Gera os arquivos estáticos do Storybook.
