# Huffman Coding

**Implementation of Huffman's code taken by an example.**

## Example:

```elixir
iex> Huffman.encode "some string"

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

iex> bit_size("some string")

88

 iex> bit_size(<<244, 55, 60, 182, 10::size(5>>)

 37
```
