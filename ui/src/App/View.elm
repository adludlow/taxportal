module App.View exposing (..)

import Html exposing (div, h1, Html, text, input, ul, li, button, p)
import Html.Attributes exposing (class, type_, placeholder)
import Html.Events exposing (onInput, onClick)
import App.Types exposing (..)

rootView : Model -> Html Msg
rootView model =
    let 
        summaryView = paygSummaryView model.paygSummary
    in
        div [class "rootContainer"] [
            Html.map PaygSummaryMsg summaryView,
            div [] [
                button [ onClick SubmitPaygSummaryMsg ] [text "Submit"]
            ],
            div [] [
                p [] [
                    text model.psarString
                ]
            ]
        ]

paygSummaryView : PaygSummary -> Html PaygSummaryMsg
paygSummaryView paygSummary =
    let
        supplierView = paygSupplierView paygSummary.paygSupplier
    in
        div [] [
            h1 [] [text "Payg Summary"],
            Html.map PaygSupplierMsg supplierView
        ]

paygSupplierView : PaygSupplier -> Html PaygSupplierMsg
paygSupplierView paygSupplier =
    let
        cdView = contactDetailsView paygSupplier.contactDetails
        supplierBusAddress = addressView paygSupplier.address
        supplierPostalAddress = addressView paygSupplier.postalAddress

    in
        div [] [
            ul []
                [ li [] [ inputField "ABN" UpdateSupplierABN ],
                  li [] [ inputField "Business Name" UpdateSupplierBusinessName ],
                  li [] [ Html.map UpdateSupplierContactDetails cdView ],
                  li [] [ Html.map UpdateSupplierBusinessAddress supplierBusAddress ],
                  li [] [ inputField "Report End Date" UpdateSupplierReportEndDate ],
                  li [] [ inputField "File Reference" UpdateSupplierFileReference ],
                  li [] [ Html.map UpdateSupplierPostalAddress supplierPostalAddress ]
                ]
        ]

inputField: String -> (String -> msg) -> Html msg
inputField fieldName msg =
    input [type_ "text", placeholder fieldName, onInput msg][]

contactDetailsView : ContactDetails -> Html ContactDetailsMsg
contactDetailsView contactDetails =
    div [] [
        ul []
            [ li [] [inputField "Name" UpdateCDName],
              li [] [inputField "Email Address" UpdateCDEmailAddress],
              li [] [inputField "Phone Number" UpdateCDPhoneNumber],
              li [] [inputField "Fax Number" UpdateCDFaxNumber]
            ]
    ]

addressView : Address -> Html AddressMsg
addressView address =
    div [] [
        ul []
            [ li [] [ inputField "Street Address 1" UpdateStreetAddress1 ],
              li [] [ inputField "Street Address 2" UpdateStreetAddress2 ],
              li [] [ inputField "Suburb" UpdateSuburb ],
              li [] [ inputField "State" UpdateState ],
              li [] [ inputField "Postcode" UpdatePostcode ],
              li [] [ inputField "Country" UpdateCountry ]
            ]
    ]
