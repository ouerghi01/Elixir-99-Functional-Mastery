defmodule ArithmeticProcessing do
  @doc """
  Determines whether a given integer is prime.

  ## Parameters
  - n: The integer to check for primality.

  ## Examples
      iex> ArithmeticProcessing.is_prime(7)
      true

      iex> ArithmeticProcessing.is_prime(4)
      false
  """
  def is_prime(n) do
    cond do
      n < 2 -> false
      rem(n,2) == 0 -> false
      true -> true
    end
  end
  @doc """
  Returns a list of prime numbers within the given range.

  ## Parameters

    - `start_range`: The starting integer of the range.
    - `end_range`: The ending integer of the range.

  ## Returns

    - A list of prime numbers within the range from `start_range` to `end_range`.

  ## Raises

    - Raises an exception if `start_range` is greater than `end_range`.

  ## Examples

      iex> ArithmeticProcessing.prime_numbers_in_range(10, 20)
      [11, 13, 17, 19]

      iex> ArithmeticProcessing.prime_numbers_in_range(20, 10)
      ** (RuntimeError) it must be start_range < end_range

  """

  def prime_numbers_in_range(a, b) when a > b do
    raise("it must be start_range < end_range")
  end
  def prime_numbers_in_range(a, b) when a == b do
    if is_prime(a), do: [a], else: []
  end
  def prime_numbers_in_range(a, b) when a < b do
    Enum.filter(a..b, fn x -> is_prime(x) end)
  end

  def goldbach(k) do
    k_primes = prime_numbers_in_range(2, k)
    Enum.find_value(k_primes, fn p ->
      q = k - p
      if is_prime(q) && Enum.member?(k_primes,q) , do: [p,q], else: nil
    end)
  end
  def goldbach_list(a,b) when  a < b do
    even_numbers = a .. b |> Enum.filter(fn x -> rem(x,2) ==0  end)
    for even <- even_numbers  do
      IO.inspect(goldbach(even))

    end
  end
  def gcd(n, m), do: Integer.gcd(n, m)

  @doc """
  Determines whether two integers are coprime (GCD equals 1).

  ## Parameters
  - n: The first integer.
  - m: The second integer.

  ## Examples
      iex> ArithmeticProcessing.coprime(35, 64)
      true

      iex> ArithmeticProcessing.coprime(36, 63)
      false
  """
  def coprime(n, m), do: gcd(n, m) == 1

  @doc """
  Calculates Euler's totient function phi(m).

  ## Parameters
  - m: The integer for which to calculate the totient function.

  ## Examples
      iex> ArithmeticProcessing.totient_phi(10)
      4
  """
  def totient_phi(m) do
    Enum.filter(1..(m - 1), fn e -> coprime(e, m) end) |> Enum.count()
  end
end

defmodule PrimeFactors do
  @doc """
  Generates the prime factors of a given number.

  ## Parameters
  - num: The number to generate prime factors for.

  ## Examples
      iex> PrimeFactors.generate(28)
      [2, 2, 7]
  """
  def generate(num), do: generate(num, 2, [])

  defp generate(1, _, acc), do: Enum.reverse(acc)

  defp generate(num, candidate, acc) when rem(num, candidate) == 0 do
    generate(div(num, candidate), candidate, [candidate | acc])
  end

  defp generate(num, candidate, acc), do: generate(num, candidate + 1, acc)

  @doc """
  Determines the prime factors of a number along with their multiplicities.

  ## Parameters
  - num: The number to analyze.

  ## Examples
      iex> PrimeFactors.prime_factors_mult(315)
      [[3, 2], [5, 1], [7, 1]]
  """
  def prime_factors_mult(num) do
    generate(num)
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.map(fn {k, v} -> [k, v] end)
  end

  @doc """
  Calculates Euler's totient function phi(m) using prime factorization.

  ## Parameters
  - m: The integer for which to calculate the totient function.

  ## Examples
      iex> PrimeFactors.phi(10)
      4
  """
  def phi(m) do
    prime_factors_mult(m)
    |> Enum.reduce(1, fn [p, m], acc ->
      acc * (p - 1) * :math.pow(p, m - 1) |> round()
    end)
  end
end
defmodule Compare do
  def compare_totient_phi do
    time_now = :os.system_time(:millisecond)
    p1 = ArithmeticProcessing.totient_phi(10090)
    time_complete = :os.system_time(:millisecond)

    time_now_s = :os.system_time(:millisecond)
    p2 = PrimeFactors.phi(10090)

    if p1 == p2 do
      IO.puts(p1)
      IO.puts(p2)
      IO.puts("its ok aziz u are loser already hhh\n")
    end

    time_complete_s = :os.system_time(:millisecond)
    diff1 = time_complete - time_now
    diff2 = time_complete_s - time_now_s

    IO.inspect(diff1)
    IO.inspect(diff2)
  end

end
