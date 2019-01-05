defmodule KeyNode do
  use GenServer

  @server KeyNode

  def start(id, successor) do
    name = returnNameForID(id)
    #    // debug: [:trace]
    GenServer.start_link(@server, [successor], name: name)
  end

  def init(data) do
    {:ok, data}
  end

  def returnNameForID(id) do
    name = :"K#{id}"
    name
  end

  def returnSuccessor(pid) do
    GenServer.call(pid, {:return_successor})
  end

  def handle_call({:return_successor}, _from, data) do
    [successor] = data

    {:reply, successor, data}
  end

end
