module Main exposing (..)

import Html exposing (..)
import Ports exposing (duration, requestDuration, DurationFormat)
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
    { remainingTime : Time.Time
    , remainingDur : Maybe DurationFormat
    }

endTime : Time.Time
endTime = 1473701400 * Time.second

init : (Model, Cmd Msg)
init = ({ remainingTime = 0, remainingDur = Nothing }, Cmd.none)


-- UPDATE


type Msg = Tick Time.Time
         | RequestDuration Time.Time
         | Duration DurationFormat


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick time ->
            ({ model | remainingTime = time }, requestDuration time)
        RequestDuration time ->
            (model, requestDuration time)
        Duration dur ->
            ({ model | remainingDur = Just dur }, Cmd.none)


countdown : Sub Msg
countdown = Time.every Time.second (\t -> Tick (endTime - t))


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.batch [ countdown, duration Duration ]


-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container", style [ ( "margin-top", "30px" ), ( "text-align", "center" ) ] ]
        [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ p [] [ text ("passy.party 🎉") ]
                , pre [] [ text <| toString <| model.remainingTime ]
                , pre [] [ text <| toString <| model.remainingDur ]
                ]
            ]
        ]
