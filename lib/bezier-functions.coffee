
module.exports.keySpline = (m_x1, m_y1, m_x2, m_y2) ->
  # linear
  A = (a1, a2) ->
    1.0 - 3.0 * a2 + 3.0 * a1
  B = (a1, a2) ->
    3.0 * a2 - 6.0 * a1
  C = (a1) ->
    3.0 * a1

  # Returns x(t) given t, x1, and x2, or y(t) given t, y1, and y2.
  calcBezier = (a_t, a1, a2) ->
    ((A(a1, a2) * a_t + B(a1, a2)) * a_t + C(a1)) * a_t

  # Returns dx/dt given t, x1, and x2, or dy/dt given t, y1, and y2.
  getSlope = (a_t, a1, a2) ->
    3.0 * A(a1, a2) * a_t * a_t + 2.0 * B(a1, a2) * a_t + C(a1)

  getTForX = (a_x) ->
    # Newton raphson iteration
    guessT = a_x
    i = 0

    while i < 4
      currentSlope = getSlope(guessT, m_x1, m_x2)
      return guessT if currentSlope is 0.0
      currentX = calcBezier(guessT, m_x1, m_x2) - a_x
      guessT -= currentX / currentSlope
      ++i
    guessT

  return (a_x) ->
    return a_x if m_x1 is m_y1 and m_x2 is m_y2
    calcBezier getTForX(a_x), m_y1, m_y2

module.exports.easing =
  ease: module.exports.keySpline(0.25, 0.1, 0.25, 1.0)
  linear: module.exports.keySpline(0.00, 0.0, 1.00, 1.0)
  ease_in: module.exports.keySpline(0.42, 0.0, 1.00, 1.0)
  ease_out: module.exports.keySpline(0.00, 0.0, 0.58, 1.0)
  ease_in_out: module.exports.keySpline(0.42, 0.0, 0.58, 1.0)
