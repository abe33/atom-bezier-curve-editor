class module.exports.UnitBezier
  constructor: (p1x, p1y, p2x, p2y) ->

    # pre-calculate the polynomial coefficients
    # First and last control points are implied to be (0,0) and (1.0, 1.0)
    @cx = 3.0 * p1x
    @bx = 3.0 * (p2x - p1x) - @cx
    @ax = 1.0 - @cx - @bx
    @cy = 3.0 * p1y
    @by = 3.0 * (p2y - p1y) - @cy
    @ay = 1.0 - @cy - @by
  epsilon: 1e-6 # Precision
  sampleCurveX: (t) ->
    ((@ax * t + @bx) * t + @cx) * t

  sampleCurveY: (t) ->
    ((@ay * t + @by) * t + @cy) * t

  sampleCurveDerivativeX: (t) ->
    (3.0 * @ax * t + 2.0 * @bx) * t + @cx

  solveCurveX: (x, epsilon) ->
    t0 = undefined
    t1 = undefined
    t2 = undefined
    x2 = undefined
    d2 = undefined
    i = undefined

    # First try a few iterations of Newton's method -- normally very fast.
    t2 = x
    i = 0

    while i < 8
      x2 = @sampleCurveX(t2) - x
      return t2  if Math.abs(x2) < epsilon
      d2 = @sampleCurveDerivativeX(t2)
      break  if Math.abs(d2) < epsilon
      t2 = t2 - x2 / d2
      i++

    # No solution found - use bi-section
    t0 = 0.0
    t1 = 1.0
    t2 = x
    return t0  if t2 < t0
    return t1  if t2 > t1
    while t0 < t1
      x2 = @sampleCurveX(t2)
      return t2  if Math.abs(x2 - x) < epsilon
      if x > x2
        t0 = t2
      else
        t1 = t2
      t2 = (t1 - t0) * .5 + t0

    # Give up
    t2


  # Find new T as a function of Y along curve X
  solve: (x, epsilon) ->
    @sampleCurveY @solveCurveX(x, epsilon)

module.exports.easing =
  ease: [0.25, 0.1, 0.25, 1.0]
  linear: [0.00, 0.0, 1.00, 1.0]
  ease_in: [0.42, 0.0, 1.00, 1.0]
  ease_out: [0.00, 0.0, 0.58, 1.0]
  ease_in_out: [0.42, 0.0, 0.58, 1.0]
