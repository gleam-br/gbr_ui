/**
 *
 */
const align_options = [
  'start', 'end', 'center', 'between', 'around', 'evenly', 'stretch'
]

/**
 *
 */
const doControlWhen = (ifWhen, doControls) => {
  let ifWhenEquals = !ifWhen || !ifWhen.eq ? {} : { if: { arg: ifWhen.arg, eq: ifWhen.eq } }
  let ifWhenNotEquals = !ifWhen || !ifWhen.neq ? {} : { if: { arg: ifWhen.arg, neq: ifWhen.neq } }

  return {
    ...ifWhenEquals,
    ...ifWhenNotEquals,
    ...doControls
  }
}

// -- API

/**
 *
 */
export const UIThemeArgs = {
  'theme.variant': 'default',
  'theme.appearance': 'default',
  'theme.state': 'idle',
  'theme.size': 'md',
  'theme.shape': 'sharp',
  'theme.elevation': 'medium',
  'theme.stacking': 'base',
  'theme.layout': 'default',
}

/**
 *
 */
export const UIVariant = (ifWhen) => {
  return doControlWhen(ifWhen, {
    control: 'select',
    options: [
      'primary', 'secondary', 'tertiary', 'success', 'info', 'warn', 'error', 'default'
    ]
  })
}

/**
 *
 */
export const UIAppearance = (ifWhen) => {
  return doControlWhen(ifWhen, {
    control: 'select',
    options: [
      'filled', 'flat', 'light', 'ghost', 'thin', 'slit', 'default'
    ]
  })
}

/**
 *
 */
export const UIState = (ifWhen) => {
  return doControlWhen(ifWhen, {
    control: 'select',
    options: [
      'disable', 'load', 'focus', 'hover', 'pressed', 'idle'
    ]
  })
}

/**
 *
 */
export const UISize = (ifWhen) => {
  return doControlWhen(ifWhen, {
    control: 'select',
    options: ['xxs', 'xs', 'sm', 'md', 'lg', 'xl', '2xl']
  })
}

/**
 *
 */
export const UIShape = (ifWhen) => {
  return doControlWhen(ifWhen, {
    control: 'select',
    options: ['sharp', 'circle', 'pill', 'shape']
  })
}

/**
 *
 */
export const UIElevation = (ifWhen) => {
  return doControlWhen(ifWhen, {
    control: 'select',
    options: ['high', 'low', 'inner', 'flat', 'medium']
  })
}

/**
 *
 */
export const UIStacking = (ifWhen) => {
  return doControlWhen(ifWhen, {
    control: 'select',
    options: [
      'tooltip', 'toast', 'modal', 'overlay', 'dropdown', 'sticky', 'float', 'base'
    ]
  })
}

export const UIAbsolute = (key) => {
  return {
    [`${key}.absolute`]: {
      control: 'select',
      options: ['axis', 'axisx', 'axisy'],
      if: { arg: `${key}`, eq: 'absolute' }
    },
    [`${key}.absolute.x`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.absolute`, eq: 'axis' },
    },
    [`${key}.absolute.y`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.absolute`, eq: 'axis' },
    },
    [`${key}.absolute.xx`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.absolute`, eq: 'axisx' },
    },
    [`${key}.absolute.yy`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.absolute`, eq: 'axisy' },
    },
  }
}
export const UIFlow = (key) => {
  return {
    [`${key}.flow`]: {
      control: 'select',
      options: [
        'main', 'cross_items', 'cross_content',
        'flow', 'flow_items', 'flow_content'
      ],
      if: { arg: `${key}`, eq: 'flow' }
    },
    [`${key}.flow.flow.main.align`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.flow`, eq: 'flow' },
    },
    [`${key}.flow.flow.items.align`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.flow`, eq: 'flow' },
    },
    [`${key}.flow.flow.content.align`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.flow`, eq: 'flow' },
    },
    [`${key}.flow.cross_main.align`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.flow`, eq: 'main' },
    },
    [`${key}.flow.cross_items.align`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.flow`, eq: 'cross_items' },
    },
    [`${key}.flow.cross_content.align`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.flow`, eq: 'cross_content' },
    },
    [`${key}.flow.flow_items.main.align`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.flow`, eq: 'flow_items' },
    },
    [`${key}.flow.flow_items.align`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.flow`, eq: 'flow_items' },
    },
    [`${key}.flow.flow_content.main.align`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.flow`, eq: 'flow_content' },
    },
    [`${key}.flow.flow_content.align`]: {
      control: 'select',
      options: align_options,
      if: { arg: `${key}.flow`, eq: 'flow_content' },
    },
  }
}
/**
 *
 */
export const UILayout = (id, ifWhen) => {
  const key = !id ? 'theme.layout' : id

  return {
    [`${key}`]: doControlWhen(ifWhen, {
      control: 'select',
      options: ['flow', 'absolute', 'default']
    }),
    ...UIAbsolute(key),
    ...UIFlow(key),
  }
}

export const UIThemeTypes = (filter) => {
  let doFilter = !filter ? {} : filter
  return {
    'theme.variant': {
      ...UIVariant(doFilter.variant),
    },
    'theme.appearance': {
      ...UIAppearance(doFilter.appearance),
    },
    'theme.state': {
      ...UIState(doFilter.state),
    },
    'theme.size': {
      ...UISize(doFilter.size),
    },
    'theme.shape': {
      ...UIShape(doFilter.shape),
    },
    'theme.elevation': {
      ...UIElevation(doFilter.elevation),
    },
    'theme.elevation.size': {
      ...UISize()
    },
    'theme.stacking': {
      ...UIStacking(doFilter.stacking),
    },
    ...UILayout(false, doFilter.layout),
    'theme.shape.size': {
      ...UISize({ arg: 'theme.shape', eq: 'shape' })
    },
    ...UILayout('theme.shape.layout', { arg: 'theme.shape', eq: 'shape' }),
  }
}
