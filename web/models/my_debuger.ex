defmodule AppPhoenix.MyDebuger do

  def echo(value, message \\ "Echo: ") do
    IO.puts message <> Kernel.inspect(value, pretty: true)
  end

end
