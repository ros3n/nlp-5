defmodule NgramReader do
  def read_digrams(file) do
    data = file
    |> File.read!
    |> String.replace(~r/#\d{6}/, "")
    |> String.replace("\n", " ")
    IO.puts "read!"
    sentences = data |> String.split(~r/\.\s(?=[A-Z]|Ś|Ź|Ó|Ż|Ć|Ł)/)
    IO.puts "got sentences!"
    beginnings = sentences |> Enum.map(fn x -> List.first(String.split(x, " ")) end)
    IO.puts "got beginnings!"
    digrams = Enum.flat_map(sentences, fn x -> generate_digrams(String.split(x)) end)
    IO.puts "generate_digrams!"
    {digrams, beginnings}
  end

  def read_word_digrams(file) do
    file
    |> File.read!
    |> String.downcase
    |> String.replace(~r/#\d{6}/, "")
    |> String.replace("\n", " ")
    |> String.replace(~r/[^\w|ś|ź|ó|ż|ą|ę|ć|ś|ł]/, "")
    |> String.split
    |> Enum.flat_map(&(generate_digrams(String.split(&1, ""))))
  end

  defp generate_digrams(enumerable) do
    enumerable |> (fn x -> Enum.zip(x, Enum.slice(x, 1..(length x))) end).()
  end
end
