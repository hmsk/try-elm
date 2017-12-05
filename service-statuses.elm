import Html exposing(..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode

main =
  Html.program
    { init = init "yet"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- Model

type alias Model = 
  { stable: Bool
  , description: String
  }

init : String -> (Model, Cmd Msg)
init service = 
  (Model False ("Not Checked anything")
  , Cmd.none
  )

-- Update

type Msg
  = HowIsCircle
  | HowIsGithub
  | HereIsCircleStatus (Result Http.Error String)
  | HereIsGithubStatus (Result Http.Error String)
  | NotCheckedYet

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NotCheckedYet ->
      (model, Cmd.none)
    HowIsCircle ->
      (Model False ("Checking CircleCI's Status..."), getCircleStatus)
    HowIsGithub ->
      (Model False ("Checking GitHub's Status..."), getGithubStatus)
    HereIsCircleStatus (Ok newDescription) ->
      (Model True newDescription, Cmd.none)
    HereIsCircleStatus (Err m) ->
      (Model False ("Couldn't get current status of CircleCI: " ++ (toString m)), Cmd.none)
    HereIsGithubStatus (Ok newDescription) ->
      (Model True newDescription, Cmd.none)
    HereIsGithubStatus (Err m) ->
      (Model False ("Couldn't get current status of Github: " ++ (toString m)), Cmd.none)


-- View

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text "Service Status Checker"]
    , p [] [text "I will check the current status of services."]
    , button [ onClick HowIsCircle ] [ text "How is Circle?"]
    , button [ onClick HowIsGithub ] [ text "How is GitHub?"]
    , h3 [] [text ("Status: " ++ (toString model.stable))]
    , p [] [text model.description]
    ]

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- Functions

getCircleStatus : Cmd Msg
getCircleStatus =
  Http.send HereIsCircleStatus (Http.get "https://6w4r0ttlx5ft.statuspage.io/api/v2/status.json" decodeCircleStatus)

decodeCircleStatus : Decode.Decoder String
decodeCircleStatus =
  Decode.at ["status", "description"] Decode.string

getGithubStatus : Cmd Msg
getGithubStatus =
  Http.send HereIsGithubStatus (Http.get "https://status.github.com/api/status.json" decodeGithubStatus)

decodeGithubStatus : Decode.Decoder String
decodeGithubStatus =
  Decode.field "status" Decode.string
