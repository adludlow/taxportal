import Html exposing(..)

main : Program Never
main = Html.program{ init = init, view = view, update = update, subscriptions = subscriptions }

type alias PaygSummary = {
    placeholder : String
}

type alias Model = {
    paygSummary : PaygSummary
}

type Msg
    = SubmitPaygSummary PaygSummary

init : (Model, Cmd Msg)
init = 
    (Model (PaygSummary ""), Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        SubmitPaygSummary paygSummary ->
            ({model | paygSummary = paygSummary}, Cmd.none)

view : Model -> Html Msg
view model = 
    div [] [
        h1 [] [text model.paygSummary.placeholder]
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
