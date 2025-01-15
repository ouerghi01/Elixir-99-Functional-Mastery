defmodule ArithmeticProcessing do
def is_prime(n) do
  cond do
    n < 2 -> false
    rem(n,2) == 0 -> false
    true -> true
  end
end
def gcd(n,m) do
  Integer.gcd(n,m)

end
def coprime(n,m) do
   cond do
    gcd(n,m) == 1-> "yes"
    true -> "No"
   end
end
def totient_phi(m) do
  Enum.filter(1..(m-1),fn e -> coprime(e,m) == "yes"  end) |> Enum.count()
end

end
defmodule PrimeFactors do
  def generate(num) do
	generate(num, 2, [])
  end

  defp generate(1, _, acc) do
	acc
  end

  defp generate(num, candidate, acc) when rem(num, candidate) == 0 do
	generate(div(num, candidate), candidate, [candidate | acc])
  end

  defp generate(num, candidate, acc) do
	generate(num, candidate + 1, acc)
  end
  def prime_factors_mult(num) do
    generate(num)|> Enum.frequencies()|> Map.to_list()|> Enum.map(fn {k,v} -> [k,v] end)
  end
end
