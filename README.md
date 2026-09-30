# 📺 GBR: UI Monorepo

Bem-vindo ao repositório oficial da **GBR UI**!
Esta é uma biblioteca open-source de componentes de interface construída inteiramente em [Gleam](https://gleam.run/) utilizando [Lustre](https://lustre.build/), inspirada nos melhores padrões de Design Systems (*Type-Safe, CVA, Tailwind CSS*).

Desenvolvido com ❤️ pela comunidade [Gleam BR](https://github.com/gleam-br).

---

## 📦 Estrutura do Monorepo

Este projeto é um monorepo que contém a biblioteca principal, o motor de histórias (Storybook) e a vitrine (Showcase).

| Pacote | Função | Documentação |
|---|---|---|
| **`core/`** | Motor CVA, Design Tokens e Componentes base. | [Ler README](./core/README.md) |
| **`storybook/`** | Motor de integração FFI entre Lustre e Storybook. | [Ler README](./storybook/README.md) |
| **`showcase/`** | Aplicação Vite com todas as histórias e testes visuais. | [Ler README](./showcase/README.md) |

## 🚀 Como Rodar Localmente

Certifique-se de ter o [Gleam](https://gleam.run/) e o [Node.js](https://nodejs.org/) instalados em sua máquina.

### Executando os Testes do Core
```bash
cd core
gleam deps download
gleam test
```

### Rodando o Storybook (Showcase)
O showcase contém o Storybook integrado para você visualizar os componentes.
```bash
cd showcase
npm install
npm run storybook
```

## 🤝 Contribuindo

Pull requests são super bem-vindos! Se você é novo no ecossistema Gleam ou quer entender mais sobre o projeto, sinta-se à vontade para perguntar.

Sempre rode `gleam format` antes de commitar e garanta que não haja erros de compilação ou de formatação.

## 📄 Licença

Este projeto é distribuído sob a licença [Apache-2.0](./LICENSE).
