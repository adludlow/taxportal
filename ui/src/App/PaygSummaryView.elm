module App.PaygSummaryView exposing(view)

import Html exposing (div, h1, text, Html, input)
import Html.Attributes exposing(class, type_, placeholder)
import Html.Events exposing(onInput)
import App.Types exposing(..)

view : msg -> App.Types.PaygSummary -> Html msg
view msg paygSummary =
        div [] [

        ]

paygSupplierView : App.Types.PaygSupplier -> Html Msg
paygSupplierView supplier =
    div [] [
        input [type_ "text", placeholder "Business Name", onInput (App.Types.SupplierMsg << BusinessName)][]
    ]
