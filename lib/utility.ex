defmodule Utility do

  @m 14
  @pow2m round(:math.pow(2, @m))

  def m do
    @m
  end

  def powerOf2 do
    @pow2m
  end

  def generateRandomNodes(numberOfNodes, index \\ 1, list \\ [])

  def generateRandomNodes(numberOfNodes, index, list) when numberOfNodes > 0 do
    randomKey = get_key(list)
    generateRandomNodes(numberOfNodes - 1, index + 1, list ++ [randomKey])
  end

  def generateRandomNodes(numberOfNodes, _, list) when numberOfNodes == 0 do
    Enum.sort(list)
  end

  def get_key(list) do
    randomKey = generate_key()

    case Enum.member?(list, randomKey) do
      true  -> get_key(list)
      false -> randomKey
    end
  end

  def generate_key do
    randomNumber = :rand.uniform(100000)
    {key, _} = Integer.parse(Base.encode16(:crypto.hash(:sha, "#{randomNumber}")), 16)
    key = rem(key, @pow2m)
    key
  end

  def isIn(low, high, id) do

    if high < low do
      Enum.member?(0..high, id) || Enum.member?(low..@pow2m-1, id)
    else
      Enum.member?(low..high, id)
    end

  end

end