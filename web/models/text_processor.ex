defmodule AppPhoenix.TextProcessor do
  # тут планируется быть разбор текста на состоявляющие

  def parse_post(body) do
    body
        # Многоточие
      |> String.replace( ~r/\.{3,}/, " __MNOGOTOCHEE__ ")
        # Дефис
      |> String.replace( ~r/\s-\s/, " __DEFIS__ ")
        # Супервопрос ?! !?
      |> String.replace( ~r/\?!|!\?/, " __SUPERVOPROS__ ")
        # Знаки припинания и пугктуации
      |> String.replace( ~r/([,?:;!.])/, " __\\1__ ", insert_replaced: 1)
      |> String.split()
      |> Stream.map(fn (i) -> do_word(i) end)
      |> Enum.to_list()
  end


  defp do_word(word) do
    cond do
      word =~ ~r/__.{1,}__/ ->
        # Специальный символ
        word <> " "
      String.length(word) < 2 ->
        # Слишком маленькое слово
        word <> "[s] "
      String.length(word) < 4 ->
        # Слишком маленькое слово
        word <> "[S] "
      word =~ ~r/-/ ->
        # Дефис
        word <> "[df," <> Integer.to_string(String.length(word)) <> "] "
      true ->
        # Обычное слово
        word <> "[" <> Integer.to_string(String.length(word)) <> "] "
    end
  end


end
