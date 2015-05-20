<a name="v0.7.0"></a>
# v0.7.0 (2015-05-20)

## :sparkles: Features

- Implement all views as custom elements ([ccb867b4](https://github.com/abe33/atom-bezier-curve-editor/commit/ccb867b4041793d7a489ddd47e34d65665f07846))

<a name="0.6.6"></a>
# 0.6.6 (2015-03-05)

## :bug: Bug Fixes

- Fix positioning issues ([a77686db](https://github.com/abe33/atom-bezier-curve-editor/commit/a77686db867aaee800667584c7703425f109e3b2))

<a name="v0.6.5"></a>
# v0.6.5 (2015-02-06)

## :bug: Bug Fixes

- Fix remaining deprecations

<a name="v0.6.4"></a>
# v0.6.4 (2015-01-26)

## :bug: Bug Fixes

- Fix selectors deprecations ([adbbdbf4](https://github.com/abe33/atom-bezier-curve-editor/commit/adbbdbf4bd65c6a7744a1e17f23933e34eb4db5c))


<a name="v0.6.3"></a>
# v0.6.3 (2015-01-26)

## :bug: Bug Fixes

- Fix deprecations ([95608d01](https://github.com/abe33/atom-bezier-curve-editor/commit/95608d01008bed4038bca17440954482a91e0168))


<a name="v0.6.2"></a>
# v0.6.2 (2014-12-08)

## :bug: Bug Fixes

- Fix bad redraw of canvas background ([cdd5dbea](https://github.com/abe33/atom-bezier-curve-editor/commit/cdd5dbeae9e7fda02afbd4f3d35b9b2863332ebe))
- Fix deprecations and broken API access.

<a name="v0.6.1"></a>
# v0.6.1 (2014-10-09)

## :bug: Bug Fixes

- Fix all deprecations ([cc507c6c](https://github.com/abe33/atom-bezier-curve-editor/commit/cc507c6c26c6639eac7068f09d9dc8d2e91abae9))
- Fix issue with floats without numerator ([289f9dc2](https://github.com/abe33/atom-bezier-curve-editor/commit/289f9dc2ec1f639cf9cb013f21374397f443d1d1), [#5](https://github.com/abe33/atom-bezier-curve-editor/issues/5))

<a name="v0.6.0"></a>
# v0.6.0 (2014-10-01)

## :sparkles: Features

- Implement support for the new context menu shouldDisplay option ([96880e80](https://github.com/abe33/atom-bezier-curve-editor/commit/96880e802fc374db892abcf3b05d6d614905701d))

<a name="v0.5.0"></a>
# v0.5.0 (2014-05-29)

## :sparkles: Features

- Add extra easing curves presets ([fe74b2b8](https://github.com/abe33/atom-bezier-curve-editor/commit/fe74b2b852baaa9aa18d7606cba85863367bf1f2),  [#2](https://github.com/abe33/atom-bezier-curve-editor/issues/2))
  <br>Includes:
  - Cubic
  - Circ
  - Expo
  - Quad
  - Quart
  - Quint
  - Sine
  - Back

## :bug: Bug Fixes

- Fix placement of the popup when editor content is small ([244e7a25](https://github.com/abe33/atom-bezier-curve-editor/commit/244e7a256f5cfce45ace3fcf3d20a1b47869df4d), [#1](https://github.com/abe33/atom-bezier-curve-editor/issues/1))
- Fix typo leading to error in conditional context menu ([27c78c52](https://github.com/abe33/atom-bezier-curve-editor/commit/27c78c524daad005dc2f0666ed45848f139ff9ed))

<a name="v0.4.0"></a>
# v0.4.0 (2014-05-29)

## :bug: Bug Fixes

- Fixes weird behavior when using mouse to select text ([8baa136](https://github.com/abe33/atom-bezier-curve-editor/commit/8baa136cb134f05a129b209fc19aae2f2785c9ff))

<a name="v0.3.0"></a>
# v0.3.0 (2014-05-29)

## :sparkles: Features

- Adds an animated preview of the timing function ([f985edb0](https://github.com/abe33/atom-bezier-curve-editor/commit/f985edb060d743fad1faad88c3489b89036911fc))


<a name="v0.2.0"></a>
# v0.2.0 (2014-05-29)

## :sparkles: Features

- Adds proper icons for presets buttons ([e2169bdc](https://github.com/abe33/atom-bezier-curve-editor/commit/e2169bdcb1fcbe513a8c446f71788e6c5143e63b))
- Adds buttons to set spline using presets ([fa767067](https://github.com/abe33/atom-bezier-curve-editor/commit/fa7670674da77c9f76c385acc68b04ae9276b309))
  <br>The UI is quite broken though
- Adds a getModel method on the view ([21cbcad6](https://github.com/abe33/atom-bezier-curve-editor/commit/21cbcad6ff9f61ebc5796d37c40bd37e9d50cfef))
  <br>Not used, but seems to be required for views in the editor.
