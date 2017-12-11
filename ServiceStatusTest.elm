module ServiceStatusTest exposing(..)

import Test exposing(..)
-- import Expect
import Test.Runner.Html
import Test.Html.Query as Query
import Test.Html.Selector exposing (text)

import ServiceStatus

main : Test.Runner.Html.TestProgram
main =
    [ suite
    ]
        |> concat
        |> Test.Runner.Html.run

suite : Test
suite =
    describe "ServiceStatus"
        [ test "has a header" <|
            \() ->
                ServiceStatus.view { stable = False, description = "" }
                    |> Query.fromHtml
                    |> Query.has [ text "Service Status Checker" ]
        , test "has given description" <|
            \() ->
                ServiceStatus.view { stable = False, description = "AWESOME DESCRIPTION" }
                    |> Query.fromHtml
                    |> Query.has [ text "AWESOME DESCRIPTION" ]
        , describe "shows stable property of model"
            [ test "for False" <|
                \() ->
                    ServiceStatus.view { stable = False, description = "" }
                        |> Query.fromHtml
                        |> Query.has [ text "Status: False" ]
            , test "for True" <|
                \() ->
                    ServiceStatus.view { stable = True, description = "" }
                        |> Query.fromHtml
                        |> Query.has [ text "Status: True" ]
            ]
        ]
