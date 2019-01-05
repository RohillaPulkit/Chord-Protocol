defmodule ChordRing do

  def initializeNetwork(numNodes) do

    node_list = createNodes(numNodes)
    node_list = Enum.sort(node_list)

    createKeyNodes(Utility.powerOf2(), node_list)

    setupNodeStates(node_list)

    node_list
  end

  def createNodes(numberOfNodes) do
    nodeList= Utility.generateRandomNodes(numberOfNodes)
    Enum.each(nodeList, fn id -> ChordNode.start(id) end)
    nodeList
  end

  def createKeyNodes(numberOfKeyNodes, node_list) do

    Enum.each(0..numberOfKeyNodes-1,
      fn id ->
        min = Enum.min(node_list)
        max = Enum.max(node_list)

        successor =
          if id > max do
            min
          else
            Enum.find(node_list, fn nodeID -> nodeID >= id end)
          end

        KeyNode.start(id, successor)
      end)
  end

  def setupNodeStates(node_list) do
    Enum.each(
      0..length(node_list)-1,
      fn id ->
        nodeID = Enum.at(node_list, id)

        successor =
          if id + 1 < length(node_list),
             do: Enum.at(node_list, id + 1),
             else: Enum.at(node_list, 0)

        predecessor =
          if id - 1 >= 0,
             do: Enum.at(node_list, id - 1),
             else: Enum.at(node_list, length(node_list) - 1)

        pid = ChordNode.returnNameForID(nodeID)

        ChordNode.setupNodeState(pid, successor, predecessor)
      end
    )
  end

end
