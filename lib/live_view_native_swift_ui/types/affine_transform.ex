defmodule LiveViewNativeSwiftUi.Types.AffineTransform do
  use LiveViewNativePlatform.Modifier.Type
  def type, do: :array

  alias LiveViewNativeSwiftUi.Types.Angle

  @identity [
    1, 0,
    0, 1,
    0, 0
  ]

  def cast(:identity), do: cast(@identity)

  def cast({:translate, {x, y}}), do: cast([
    1, 0,
    0, 1,
    x, y
  ])

  def cast({:scale, {x, y}}), do: cast([
    x, 0,
    0, y,
    0, 0
  ])

  def cast({:scale, factor}), do: cast({:scale, {factor, factor}})

  def cast({:rotate, angle}) do
    with {:ok, radians} <- Angle.cast(angle) do
      cast([
        :math.cos(radians),  :math.sin(radians),
        -:math.sin(radians), :math.cos(radians),
        0,                   0,
      ])
    else
      _ ->
        :error
    end
  end

  def cast([
    m11, m12,
    m21, m22,
    tx, ty
  ] = matrix)
    when is_number(m11) and is_number(m12)
    and is_number(m21) and is_number(m22)
    and is_number(tx) and is_number(ty),
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
    m11, m12,
    m21, m22,
    tx, ty
  ]), do: %{
    m11: m11, m12: m12,
    m21: m21, m22: m22,
    tx: tx, ty: ty
  }

  defp concat(a, b) do
    # Implemented according to the swift-corelibs-foundation docs:
    #       [ a1, b1, 0 ]   [ a2, b2, 0 ]
    # A×B = [ c1, d1, 0 ] × [ c2, d2, 0 ]
    #       [ x1, y1, 1 ]   [ x2, y2, 1 ]
    #
    #       [ a1*a2+b1*c2+0*x2 a1*b2+b1*d2+0*y2 a1*0+b1*0+0*1 ]
    # A×B = [ c1*a2+d1*c2+0*x2 c1*b2+d1*d2+0*y2 c1*0+d1*0+0*1 ]
    #       [ x1*a2+y1*c2+1*x2 x1*b2+y1*d2+1*y2 x1*0+y1*0+1*1 ]
    #
    #       [   a1*a2+b1*c2    a1*b2+b1*d2        0 ]
    # A×B = [   c1*a2+d1*c2    c1*b2+d1*d2        0 ]
    #       [ x1*a2+y1*c2+x2  x1*b2+y1*d2+y2      1 ]
    a = as_map(a)
    b = as_map(b)
    [
      (a[:m11] * b[:m11]) + (a[:m12] * b[:m21]),        (a[:m11] * b[:m12]) + (a[:m12] * b[:m22]),
      (a[:m21] * b[:m11]) + (a[:m22] * b[:m21]),        (a[:m21] * b[:m12]) + (a[:m22] * b[:m22]),
      (a[:tx] * b[:m11]) + (a[:ty] * b[:m21]) + b[:tx], (a[:tx] * b[:m12]) + (a[:ty] * b[:m22]) + b[:ty],
    ]
  end
end
