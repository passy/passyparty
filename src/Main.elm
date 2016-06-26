module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Time as Time


-- APP


main : Program Never
main =
    Html.program { init = init
                 , view = view
                 , update = update
                 , subscriptions = subscriptions }



-- MODEL


type alias Model =
    { currentTime : Time.Time }


init : (Model, Cmd Msg)
init = ({ currentTime = 0 }, Cmd.none)


-- UPDATE


type Msg = Tick Time.Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick time ->
            ({ currentTime = time }, Cmd.none)


currentTime : Sub Msg
currentTime = Time.every Time.second Tick


subscriptions : Model -> Sub Msg
subscriptions _ = currentTime


-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container", style [ ( "margin-top", "30px" ), ( "text-align", "center" ) ] ]
        [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ p [] [ text ("passy-party") ]
                , pre [] [ text <| toString <| model.currentTime ]
                ]
            ]
        ]
