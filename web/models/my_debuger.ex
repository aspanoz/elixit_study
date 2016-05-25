defmodule AppPhoenix.MyDebuger do

  def echo(value, message \\ "Echo: ") do
    IO.puts message <> Kernel.inspect(value, pretty: true)
  end

  def echo_bypass(value, message \\ "Echo: ") do
    echo(value, message)
    value
  end


end
