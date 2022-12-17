defmodule Huffman do
  defmodule Node do
    defstruct [:left, :right]
  end

  defmodule Leaf do
    defstruct [:value]
  end

  @moduledoc """
  Documentation for `Huffman`.
  """

  @doc """
  Huffman Coding.

  ## Examples

      iex> Huffman.encode("some string")

      {%Huffman.Node{
   left: %Huffman.Node{
     left: %Huffman.Node{
       left: %Huffman.Leaf{value: "m"},
       right: %Huffman.Leaf{value: "n"}
     },
     right: %Huffman.Node{
       left: %Huffman.Leaf{value: "g"},
       right: %Huffman.Leaf{value: "i"}
     }
   },
   right: %Huffman.Node{
     left: %Huffman.Node{
       left: %Huffman.Leaf{value: "t"},
       right: %Huffman.Node{
         left: %Huffman.Leaf{value: "o"},
         right: %Huffman.Leaf{value: "r"}
       }
     },
     right: %Huffman.Node{
       left: %Huffman.Node{
         left: %Huffman.Leaf{value: " "},
         right: %Huffman.Leaf{value: "e"}
       },
       right: %Huffman.Leaf{value: "s"}
     }
   }
 }, <<244, 55, 60, 182, 10::size(5)>>}

  """
  def encode(text \\ "cheesecake") do
    frequencies =
      text
      |> String.graphemes()
      |> Enum.reduce(%{}, fn char, map ->
        Map.update(map, char, 1, fn val -> val + 1 end)
      end)

    queue =
      frequencies
      |> Enum.sort_by(fn {_char, frequency} -> frequency end)
      |> Enum.map(fn {value, frequency} ->
        {
          %Leaf{value: value},
          frequency
        }
      end)

    tree = build(queue)
    {tree, convert(text, tree)}
  end

  def decode(tree, data, result \\ [])

  def decode(_tree, <<>>, result),
    do: List.to_string(result)

  def decode(tree, data, result) do
    {rest, value} = walk(data, tree)
    decode(tree, rest, result ++ [value])
  end

  defp walk(binary, %Leaf{value: value}), do: {binary, value}

  defp walk(<<0::size(1), rest::bitstring>>, %Node{left: left}) do
    walk(rest, left)
  end

  defp walk(<<1::size(1), rest::bitstring>>, %Node{right: right}) do
    walk(rest, right)
  end

  defp build([{root, _freq}]), do: root

  defp build(queue) do
    [{node_a, freq_a} | queue] = queue
    [{node_b, freq_b} | queue] = queue

    new_node = %Node{
      left: node_a,
      right: node_b
    }

    total = freq_a + freq_b

    queue = [{new_node, total}] ++ queue

    queue
    |> Enum.sort_by(fn {_node, frequency} -> frequency end)
    |> build()
  end

  defp find(tree, character, path \\ <<>>)

  defp find(%Leaf{value: value}, character, path) do
    case value do
      ^character -> path
      _ -> nil
    end
  end

  defp find(%Node{left: left, right: right}, character, path) do
    find(left, character, <<path::bitstring, 0::size(1)>>) ||
      find(right, character, <<path::bitstring, 1::size(1)>>)
  end

  defp convert(text, tree) do
    text
    |> String.graphemes()
    |> Enum.reduce(<<>>, fn character, binary ->
      code = find(tree, character)

      <<binary::bitstring, code::bitstring>>
    end)
  end
end
