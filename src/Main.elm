module Main exposing (..)

import Html exposing (..)
import Ports exposing (duration, requestDuration, DurationFormat)
import Cmd.Extra exposing (message)
import Html.Attributes exposing (..)
import Html.App as Html
import Time as Time
import Task as Task
import String as String


-- APP


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type Url
    = Url String


runUrl : Url -> String
runUrl (Url s) =
    s


type alias Model =
    { remainingTime : Time.Time
    , remainingDur : Maybe DurationFormat
    , imageUrl : Maybe Url
    }


endTime : Time.Time
endTime =
    1474272000 * Time.second


endImage : Url
endImage =
    Url "//giphy.com/embed/JdCz7YXOZAURq?html5=true"


init : ( Model, Cmd Msg )
init =
    ( { remainingTime = 0, remainingDur = Nothing, imageUrl = Nothing }, message RequestTick )



-- UPDATE


type Msg
    = Tick Time.Time
    | Tock Url
    | Noop
    | RequestTick
    | Duration DurationFormat


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { model | remainingTime = time }, requestDuration time )

        Tock url ->
            ( { model | imageUrl = Just url }, Cmd.none )

        Noop ->
            model ! []

        RequestTick ->
            ( model, Task.perform (\_ -> Noop) evalTime Time.now )

        Duration dur ->
            ( { model | remainingDur = Just dur }, Cmd.none )


evalTime : Time.Time -> Msg
evalTime t =
    let
        dur =
            endTime - t
    in
        if dur > 0 then
            Tick dur
        else
            Tock endImage


countdown : Sub Msg
countdown =
    Time.every Time.second evalTime


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ countdown, duration Duration ]



-- VIEW


pluralize : Float -> String -> String
pluralize i word =
    case floor i of
        1 ->
            word

        _ ->
            word ++ "s"


formatDuration : DurationFormat -> String
formatDuration dur =
    String.join " "
        [ toString dur.days
        , pluralize dur.days "day"
        , toString dur.hours
        , pluralize dur.hours "hour"
        , toString dur.minutes
        , pluralize dur.minutes "minute"
        , toString dur.seconds
        , pluralize dur.seconds "second"
        ]


view : Model -> Html Msg
view model =
    div [ class "container-fluid", style [ ( "margin-top", "30px" ), ( "text-align", "center" ) ] ]
        [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ h1 [] [ text "🎉" ]
                , innerView model
                ]
            ]
        ]


innerView : Model -> Html Msg
innerView model =
    case model.imageUrl of
        Just url ->
            imageView url

        Nothing ->
            countDownView model.remainingDur


imageView : Url -> Html Msg
imageView (Url u) =
    iframe [ attribute "height" "269", attribute "width" "480", attribute "frameBorder" "0", src u ] []


countDownView : Maybe DurationFormat -> Html Msg
countDownView dur =
    let
        duration =
            case dur of
                Just d ->
                    text <| formatDuration <| d

                Nothing ->
                    text ""
    in
        p [ style [ ( "margin-top", "15px" ) ] ] [ duration ]
