export const range = (start, stop, step = 1) => Array.from({
  length: (stop - start - 1) / step + 1
}, (_, i) => start + (i * step))