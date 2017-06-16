module ZipListTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, list, int, string)
import Test exposing (..)
import ZipList exposing (ZipList)


suite : Test
suite =
    describe "The ZipList module"
        [ fuzz (list int) "The toList function" <|
            \randomList ->
                Expect.equal randomList (ZipList.fromList randomList |> ZipList.toList)
        , describe "The current function"
            [ test "An empty list should return Nothing" <|
                \_ ->
                    Expect.equal Nothing (ZipList.fromList [] |> ZipList.current)
            , test "A non empty list" <|
                \_ ->
                    Expect.equal (Just 1) (ZipList.fromList [ 1, 2 ] |> ZipList.current)
            ]
        , describe "The next function" <|
            [ moveTest "An empty list" ZipList.forward [] Nothing
            , moveTest "already at the list end" ZipList.forward [ 1 ] (Just 1)
            , moveTest "still some moves to make" ZipList.forward [ 1, 2 ] (Just 2)
            ]
        , describe "The previous function" <|
            [ moveTest "An empty list" ZipList.backward [] Nothing
            , moveTest "already at the list beginning" ZipList.backward [ 1 ] (Just 1)
            , moveTest "still some moves to make" (ZipList.forward >> ZipList.backward) [ 1, 2 ] (Just 1)
            ]
        , fuzz (list int) "The length function" <|
            \randomList ->
                Expect.equal (List.length randomList) (ZipList.length <| ZipList.fromList randomList)
        ]


{-| Given a "move" function, a list of item, returns an expectation that will check that the current value of the built ziplist will be equal to the given expected value
-}
moveTest : String -> (ZipList a -> ZipList a) -> List a -> Maybe a -> Test
moveTest testLabel moveFunc list expectedValue =
    test testLabel <|
        \_ ->
            let
                zipList =
                    ZipList.fromList list

                nextZipList =
                    moveFunc zipList
            in
                Expect.equal expectedValue (ZipList.current nextZipList)
