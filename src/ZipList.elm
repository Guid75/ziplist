module ZipList
    exposing
        ( ZipList
        , fromList
        , singleton
        , current
        , forward
        , backward
        , toList
        , length
        )

{-| A ZipList is a collection which can be moved forward/backward and that exposes a single current element

@docs ZipList, fromList, singleton, current, forward, backward, toList, length

-}


{-| A collection data type that can be moved forward/backward and that exposes a current element
-}
type ZipList a
    = Empty
    | Zipper (List a) a (List a)


{-| Craft a new ZipList out of a List
-}
fromList : List a -> ZipList a
fromList list =
    case list of
        [] ->
            Empty

        head :: queue ->
            Zipper [] head queue


{-| Create a new ZipList with a single element in it
-}
singleton : a -> ZipList a
singleton item =
    Zipper [] item []


{-| Return the current element of a ZipList
-}
current : ZipList a -> Maybe a
current zipList =
    case zipList of
        Empty ->
            Nothing

        Zipper _ current _ ->
            Just current


performIfNonEmpty : (List a -> a -> List a -> ZipList a) -> ZipList a -> ZipList a
performIfNonEmpty f zipList =
    case zipList of
        Empty ->
            zipList

        Zipper before current after ->
            f before current after


{-| Move forward a ZipList
-}
forward : ZipList a -> ZipList a
forward zipList =
    performIfNonEmpty
        (\before current after ->
            case after of
                [] ->
                    Zipper before current after

                head :: queue ->
                    Zipper (current :: before) head queue
        )
        zipList


{-| Move backward a ZipList
-}
backward : ZipList a -> ZipList a
backward zipList =
    performIfNonEmpty
        (\before current after ->
            case before of
                [] ->
                    Zipper before current after

                head :: queue ->
                    Zipper queue head (current :: after)
        )
        zipList


{-| Convert a ZipList into a List
-}
toList : ZipList a -> List a
toList zipList =
    case zipList of
        Empty ->
            []

        Zipper before current after ->
            List.concat
                [ List.reverse before
                , [ current ]
                , after
                ]


{-| Return a ziplist length
-}
length : ZipList a -> Int
length zipList =
    case zipList of
        Empty ->
            0

        Zipper before _ after ->
            1 + (List.length before) + (List.length after)
