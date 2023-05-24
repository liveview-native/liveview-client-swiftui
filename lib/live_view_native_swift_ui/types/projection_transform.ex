defmodule LiveViewNativeSwiftUi.Types.ProjectionTransform do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :array

  alias LiveViewNativeSwiftUi.Types.Angle

  @identity [
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  ]

  def cast(:identity), do: cast(@identity)

  def cast({:translate, {x, y, z}}), do: cast([
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    x, y, z, 1
  ])

  def cast({:scale, {x, y, z}}), do: cast([
    x, 0, 0, 0,
    0, y, 0, 0,
    0, 0, z, 0,
    0, 0, 0, 1
  ])

  def cast({:scale, factor}), do: cast({:scale, {factor, factor, factor}})

  def cast({:rotate, angle, {x, y, z}}) do
    with {:ok, r} <- Angle.cast(angle) do
      magnitude = :math.sqrt((x*x) + (y*y) + (z*z))
      r = r / 2
      s = :math.sin(r)
      c = :math.cos(r)
      {x, y, z} = {x / magnitude * s, y / magnitude * s, z / magnitude * s}
      cast([
        1 - 2 * (y * y + z * z), 2 * (x * y + z * c), 2 * (x * z - y * c), 0,
        2 * (x * y - z * c), 1 - 2 * (x * x + z * z), 2 * (y * z + x * c), 0,
        2 * (x * z + y * c), 2 * (y * z - x * c), 1 - 2 * (x * x + y * y), 0,
        0, 0, 0, 1
      ])
    else
      _ ->
        :error
    end
  end

  def cast([
    m11, m12,
    m21, m22,
    m31, m32
  ])
    when is_number(m11) and is_number(m12)
    and is_number(m21) and is_number(m22)
    and is_number(m31) and is_number(m32),
  do: cast([
    m11, m12, 0, 0,
    m21, m22, 0, 0,
    m31, m32, 1, 0,
    0, 0, 0, 1
  ])

  def cast([
    m11, m12, m13, m14,
    m21, m22, m23, m24,
    m31, m32, m33, m34,
    m41, m42, m43, m44
  ] = matrix)
    when is_number(m11) and is_number(m12) and is_number(m13) and is_number(m14)
    and is_number(m21) and is_number(m22) and is_number(m23) and is_number(m24)
    and is_number(m31) and is_number(m32) and is_number(m33) and is_number(m34)
    and is_number(m41) and is_number(m42) and is_number(m43) and is_number(m44),
  do: {:ok, matrix}

  def cast(transforms) when is_list(transforms),
    do: Enum.reduce(
      transforms,
      {:ok, @identity},
      fn element, acc ->
        with {:ok, acc} <- acc,
             {:ok, element} <- cast(element)
        do
          {:ok, concat(element, acc)}
        else
          _ ->
            :error
        end
      end
    )

  def cast(_), do: :error

  defp as_map([
    m11, m12, m13, m14,
    m21, m22, m23, m24,
    m31, m32, m33, m34,
    m41, m42, m43, m44
  ]), do: %{
    m11: m11, m12: m12, m13: m13, m14: m14,
    m21: m21, m22: m22, m23: m23, m24: m24,
    m31: m31, m32: m32, m33: m33, m34: m34,
    m41: m41, m42: m42, m43: m43, m44: m44
  }

  defp concat(a, b) do
    a = as_map(a)
    b = as_map(b)
    [
      a[:m11] * b[:m11] + a[:m12] * b[:m21] + a[:m13] * b[:m31] + a[:m14] * b[:m41],
      a[:m11] * b[:m12] + a[:m12] * b[:m22] + a[:m13] * b[:m32] + a[:m14] * b[:m42],
      a[:m11] * b[:m13] + a[:m12] * b[:m23] + a[:m13] * b[:m33] + a[:m14] * b[:m43],
      a[:m11] * b[:m14] + a[:m12] * b[:m24] + a[:m13] * b[:m34] + a[:m14] * b[:m44],
      a[:m21] * b[:m11] + a[:m22] * b[:m21] + a[:m23] * b[:m31] + a[:m24] * b[:m41],
      a[:m21] * b[:m12] + a[:m22] * b[:m22] + a[:m23] * b[:m32] + a[:m24] * b[:m42],
      a[:m21] * b[:m13] + a[:m22] * b[:m23] + a[:m23] * b[:m33] + a[:m24] * b[:m43],
      a[:m21] * b[:m14] + a[:m22] * b[:m24] + a[:m23] * b[:m34] + a[:m24] * b[:m44],
      a[:m31] * b[:m11] + a[:m32] * b[:m21] + a[:m33] * b[:m31] + a[:m34] * b[:m41],
      a[:m31] * b[:m12] + a[:m32] * b[:m22] + a[:m33] * b[:m32] + a[:m34] * b[:m42],
      a[:m31] * b[:m13] + a[:m32] * b[:m23] + a[:m33] * b[:m33] + a[:m34] * b[:m43],
      a[:m31] * b[:m14] + a[:m32] * b[:m24] + a[:m33] * b[:m34] + a[:m34] * b[:m44],
      a[:m41] * b[:m11] + a[:m42] * b[:m21] + a[:m43] * b[:m31] + a[:m44] * b[:m41],
      a[:m41] * b[:m12] + a[:m42] * b[:m22] + a[:m43] * b[:m32] + a[:m44] * b[:m42],
      a[:m41] * b[:m13] + a[:m42] * b[:m23] + a[:m43] * b[:m33] + a[:m44] * b[:m43],
      a[:m41] * b[:m14] + a[:m42] * b[:m24] + a[:m43] * b[:m34] + a[:m44] * b[:m44]
    ]
  end
end
