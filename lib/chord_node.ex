defmodule ChordNode do
  use GenServer

  @server ChordNode

  def start(id) do
    name = returnNameForID(id)
    #    // debug: [:trace]
    GenServer.start_link(@server, [id], name: name)
  end

  def init(data) do
    {:ok, data}
  end

  def returnNameForID(id) do
    name = :"N#{id}"
    name
  end

  def setupNodeState(pid, successor, predecessor) do
    GenServer.call(pid, {:setup_node_state, successor, predecessor})
  end

  def findSuccessor(pid, id, hopCount \\0) do
    GenServer.call(pid, {:find_successor, id, hopCount})
  end

  def closestPrecedingNode(pid, fingerTable, id) do

    [_, precedingNode] =  Enum.find(Enum.reverse(fingerTable), fn
      [_, node] ->
        Utility.isIn(pid+1, id-1, node)
      end)
    precedingNode
  end

  def handle_call({:setup_node_state, successor, predecessor}, _from, data) do

    index = case length(data) do
      1 -> [index] = data
      index
      4 -> [index, _, _, _] = data
      index
      true -> IO.puts("Something went wrong.")
    end

    fingerTable =
      Enum.reduce(0..(Utility.m() - 1), [], fn k, list ->
        keyNodeID = rem(round(index + :math.pow(2, k)), Utility.powerOf2())
        keyNode =  KeyNode.returnNameForID(keyNodeID)
        nodeSuccessor = KeyNode.returnSuccessor(keyNode)
        Enum.concat(list, [[keyNode, nodeSuccessor]])
      end)

    newData = [index, fingerTable, successor, predecessor]

#    IO.puts(
#      "N#{inspect(index)}:\t Sucessor:#{inspect(successor)},\tPredecessor:#{inspect(predecessor)},\t FingerTable:#{inspect(fingerTable)}"
#    )

    {:reply, "Updated Finger Table", newData}
  end

  def handle_call({:find_successor, id, hopCount}, _from, data) do

    [index, fingerTable, successor, _] = data

    {hopString, successorNode, newHopCount} = if Utility.isIn(index, successor, id) do
      {"#{successor}", successor, hopCount}
      else
      precedingNode = closestPrecedingNode(index, fingerTable, id)
      ChordNode.findSuccessor(returnNameForID(precedingNode), id, hopCount+1)
    end

    {:reply, {"#{index}->#{hopString}", successorNode, newHopCount}, data}
  end

end
