/**
 * Cria a função render para as histórias (storybook) do Lustre.
 *
 * @param coreMountFn - A função universal mount.
 */
export function do_render(coreMountFn) {

  return function render(args, context, gleamViewFn) {
    const container = document.createElement("div");
    container.id = context.id;
    const selector = `#${container.id}`;

    const observer = new MutationObserver((mutations) => {
      for (const mutation of mutations) {
        if (Array.from(mutation.addedNodes).includes(container) || container.parentNode) {

          // Quando o DOM estiver pronto, chamamos o motor passando os argumentos
          // A função 'onAction' já é extraída automaticamente de args.onAction (padrão do Storybook 10+)
          coreMountFn(
            selector,
            args,
            gleamViewFn,
            (msg) => {
              if (typeof args.onAction === 'function') {
                args.onAction(msg);
              }
            }
          );

          observer.disconnect();
        }
      }
    });

    observer.observe(context.canvasElement, { childList: true, subtree: true });
    return container;
  };
}
