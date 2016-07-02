port module Ports exposing (DurationFormat, duration, requestDuration)

import Time as Time

type alias DurationFormat =
    { days : Time.Time
    , hours : Time.Time
    , minutes : Time.Time
    , seconds : Time.Time
    }

port requestDuration : Time.Time -> Cmd msg

port duration : (DurationFormat -> msg) -> Sub msg
