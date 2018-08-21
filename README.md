# ziplist

A ZipList is a type of collection in which you can move a pointer on a current element forwards or backwards.

Here is a simple example:

```elm
import ZipList exposing (..)

zlist : ZipList.ZipList Number
zlist = ZipList.fromList [1, 2, 3] -- this ziplist points on the first element (1) after creation

a : Maybe Number
a = ZipList.current zlist -- worth Just 1

b : Maybe Number
b =
    zlist
        |> ZipList.forward
        |> ZipList.forward
        |> ZipList.current -- worth Just 3

list = ZipList.toList zlist -- worth [1, 2, 3]
```
