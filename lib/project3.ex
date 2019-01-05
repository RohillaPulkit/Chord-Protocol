defmodule Project3 do
  @moduledoc """
  takes up the arguments from the command line and process the input
  """
  @errorString "Error: Invalid Input \nValid input: ./project3 numNodes numRequests"

  def main(args) do
    with parsedArgs = args |> parse_args() do
      cond do
        length(parsedArgs) == 2 ->
          [numNodes, numRequests] = parsedArgs
          if numRequests > 0 do
            nodeList = ChordRing.initializeNetwork(numNodes)
            beginRouting(nodeList, numRequests)
          else
            IO.puts("Error: Number of requests can't be 0")
          end
        true ->
          IO.puts(@errorString)
      end
    end
  end

  @doc """
  Parse the arguments into the required form
  """
  def parse_args(args) when length(args) != 2 do
    IO.puts(@errorString)

    # stop the program from running
    System.halt(0)
  end

  def parse_args(args) do
    args
    |> args_to_internal_representation()
  end

  defp args_to_internal_representation([numNodes, numRequests]) do
    [toInteger(numNodes), toInteger(numRequests)]
  end

  def toInteger(number) do
    if match?({_, ""}, Integer.parse(number)) do
      value = String.to_integer(number)
      value
    else
      IO.puts(@errorString)
      System.halt(0)
    end
  end

  def beginRouting(nodeList, numRequests) do

    requestKeys = Utility.generateRandomNodes(numRequests)

    totalHops = Enum.reduce(requestKeys, 0, fn key, hops ->

      totalHopCount = Enum.reduce(nodeList, 0, fn nodeID, acc ->
        pid = ChordNode.returnNameForID(nodeID)
        {_, _, hopCount} = ChordNode.findSuccessor(pid, key)

#        IO.puts("For Key: K#{key} ID : N#{nodeID} Successor : N#{successorNode} and Hops : #{hopCount} (#{hopString})" )

        acc + hopCount
      end)

      averageHops = (totalHopCount / length(nodeList)) |> Float.round(2)
      IO.puts("Average Number Of Hops : #{averageHops}")

      hops + averageHops
    end)

    IO.puts("\nOverall Average : #{totalHops/numRequests |> Float.round(2)}")

  end

end
