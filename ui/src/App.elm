module App exposing (main)

import Html
import App.State
import App.View
import App.Types

main : Program Never App.Types.Model App.Types.Msg
main = Html.program
    { init = App.State.initialState
    , update = App.State.update
    , subscriptions = App.State.subscriptions
    , view = App.View.rootView
    }
