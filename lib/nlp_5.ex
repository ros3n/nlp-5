defmodule Nlp_5 do
  def generate_paragraph(_, _, 0), do: ""

  def generate_paragraph(model, beginnings, sentences) do
    first_word = Enum.random beginnings
    generate_sentence(model, first_word) <> " " <> generate_paragraph(model, beginnings, sentences - 1)
  end

  def generate_sentence(model, first_word) do
    nw = draw_next_word(model, first_word)
    if String.ends_with? nw, [".", "!", "?"] do
      first_word <> " " <> nw
    else
      first_word <> " " <> generate_sentence(model, nw)
    end
  end

  def generate_word(_, first_char, 0), do: first_char

  def generate_word(model, first_char, length) do
    nw = draw_next_word(model, first_char)
    first_char <> generate_word(model, nw, length - 1)
  end

  defp draw_next_word(model, previous_word) do
    candidates = model[previous_word]
    case candidates do
      nil ->
        "."
      _ ->
        candidates
        |> Map.to_list
        |> next_word(0, :random.uniform)
    end
  end

  defp next_word([{k, _}], _, _), do: k

  defp next_word([{k, v}|candidates], acc, rand) do
    if v + acc > rand do
      k
    else
      next_word(candidates, acc + v, rand)
    end
  end
end
