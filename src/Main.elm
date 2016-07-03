module Main exposing (..)

import Html exposing (..)
import Ports exposing (duration, requestDuration, DurationFormat)
import Html.Attributes exposing (..)
import Html.App as Html
import Time as Time
import String as String


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

formatDuration : DurationFormat -> String
formatDuration dur =
    String.join " " [ toString dur.days
                    , "days"
                    , toString dur.hours
                    , "hours"
                    , toString dur.minutes
                    , "minutes"
                    , toString dur.seconds
                    , "seconds"
                    ]

view : Model -> Html Msg
view model =
    let duration = case model.remainingDur of
        Just d  -> text <| formatDuration <| d
        Nothing -> text ""
    in div [ class "container-fluid", style [ ( "margin-top", "30px" ), ( "text-align", "center" ) ] ]
        [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ h1 [] [ text "🎉" ]
                , p [ style [ ( "margin-top", "15px" ) ] ] [ duration ]
                ]
            ]
        ]
