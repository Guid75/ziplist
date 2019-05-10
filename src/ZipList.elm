module ZipList exposing
    ( ZipList
    , fromList, singleton
    , current, toList, length
    , forward, backward
    )

{-| A `ZipList` is a collection which can be moved forward/backward and that exposes a single current element


# ZipLists

@docs ZipList


# Creation

@docs fromList, singleton


# Consultation

@docs current, toList, length


# Moving

@docs forward, backward

-}

import Maybe


{-| A collection data type that can be moved forward/backward and that exposes a current element (see the `current` function)
-}
type ZipList a
    = Empty
    | Zipper (List a) a (List a)


{-| Craft a new `ZipList` out of a List
-}
fromList : List a -> ZipList a
fromList list =
    case list of
        [] ->
            Empty

        head :: queue ->
            Zipper [] head queue


{-| Create a new `ZipList` with a single element in it
-}
singleton : a -> ZipList a
singleton item =
    Zipper [] item []


{-| Return the current element of a `ZipList`. `Nothing` will be returned if the ziplist is empty
-}
current : ZipList a -> Maybe a
current zipList =
    case zipList of
        Empty ->
            Nothing

        Zipper _ elem _ ->
            Just elem


{-| Move forward a `ZipList`
-}
forward : ZipList a -> ZipList a
forward zipList =
    case zipList of
        Empty ->
            zipList

        Zipper before elem after ->
            case after of
                [] ->
                    zipList

                head :: queue ->
                    Zipper (elem :: before) head queue


{-| Move backward a `ZipList`
-}
backward : ZipList a -> ZipList a
backward zipList =
    case zipList of
        Empty ->
            zipList

        Zipper before elem after ->
            case before of
                [] ->
                    zipList

                head :: queue ->
                    Zipper queue head (elem :: after)


{-| Convert a `ZipList` into a `List`
-}
toList : ZipList a -> List a
toList zipList =
    case zipList of
        Empty ->
            []

        Zipper before elem after ->
            List.concat
                [ List.reverse before
                , [ elem ]
                , after
                ]


{-| Return a `ZipList` length
-}
length : ZipList a -> Int
length zipList =
    case zipList of
        Empty ->
            0

        Zipper before _ after ->
            1 + List.length before + List.length after
