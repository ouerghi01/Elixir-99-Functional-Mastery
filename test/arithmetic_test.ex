defmodule ArithmeticProcessingTest do
  use ExUnit.Case
  alias ArithmeticProcessing

  test "is_prime/1 with prime numbers" do
    assert ArithmeticProcessing.is_prime(2) == true
    assert ArithmeticProcessing.is_prime(3) == true
    assert ArithmeticProcessing.is_prime(5) == true
  end

  test "is_prime/1 with non-prime numbers" do
    assert ArithmeticProcessing.is_prime(1) == false
    assert ArithmeticProcessing.is_prime(4) == false
    assert ArithmeticProcessing.is_prime(6) == false
  end

  test "gcd/2" do
    assert ArithmeticProcessing.gcd(54, 24) == 6
    assert ArithmeticProcessing.gcd(48, 18) == 6
    assert ArithmeticProcessing.gcd(101, 10) == 1
  end

  test "coprime/2" do
    assert ArithmeticProcessing.coprime(13, 27) == "yes"
    assert ArithmeticProcessing.coprime(12, 18) == "No"
  end

  test "totient_phi/1" do
    assert ArithmeticProcessing.totient_phi(9) == 6
    assert ArithmeticProcessing.totient_phi(10) == 4
  end
end

defmodule PrimeFactorsTest do
  use ExUnit.Case
  alias PrimeFactors

  test "generate/1" do
    assert PrimeFactors.generate(315) == [7, 5, 3, 3]
    assert PrimeFactors.generate(60) == [5, 3, 2, 2]
  end

  test "prime_factors_mult/1" do
    assert PrimeFactors.prime_factors_mult(315) == [[3, 2], [5, 1], [7, 1]]
    assert PrimeFactors.prime_factors_mult(60) == [[2, 2], [3, 1], [5, 1]]
  end
  test "PrimeFactors.phi/1" do
    assert PrimeFactors.phi(9) == 6
    assert PrimeFactors.phi(10) == 4
  end
  test "gray/1" do
    assert Logic.gray(1) == [0, 1]
    assert Logic.gray(3) == ["000", "001", "011", "010", "110", "111", "101", "100"]

  end

end
