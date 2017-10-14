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
        payerView = paygPayerView paygSummary.paygPayer
    in
        div [] [
            h1 [] [text "Payg Summary"],
            Html.map PaygSupplierMsg supplierView,
            Html.map PaygPayerMsg payerView
        ]

paygPayerView : PaygPayer -> Html PaygPayerMsg
paygPayerView paygPayer =
    let
        addrView = addressView paygPayer.address
        cdView = contactDetailsView paygPayer.contactDetails
        inbView = paygIndividualNonBusinessPaymentSummaryView paygPayer.inb
    in
        div [] [
            h1 [] [ text "Payg Payer" ],
            ul [] [
                li [] [ inputField "ABN" UpdatePayerABN ],
                li [] [ inputField "Branch Number" UpdatePayerBranchNumber ],
                li [] [ inputField "Business Name" UpdatePayerBusinessName ],
                li [] [ Html.map UpdatePayerAddress addrView ],
                li [] [ Html.map UpdatePayerContactDetails cdView ],
                li [] [ inputField "Trading Name" UpdatePayerTradingName ],
                li [] [ inputField "Financial Year" UpdatePayerFinancialYear ],
                li [] [ Html.map UpdateINBMsg inbView ]
            ]
        ]

paygPayeeView : PaygPayee -> Html PaygPayeeMsg
paygPayeeView paygPayee =
    let
        addrView = addressView paygPayee.address
        individualNonBusinessPaymentSummaryView = paygIndividualNonBusinessPaymentSummaryView paygPayee.inb
    in
        div [] [
            h1 [] [ text "Payg Payee" ],
            ul [] [
                li [] [ inputField "Tax File Number" UpdatePayeeTaxFileNumber ],
                li [] [ inputField "First Name" UpdatePayeeFirstName ],
                li [] [ inputField "Last Name" UpdatePayeeLastName ],
                li [] [ inputField "Second Name" UpdatePayeeSecondName ],
                li [] [ inputField "DOB" UpdatePayeeDOB ],
                li [] [ Html.map UpdatePayeeAddress addrView ],
                li [] [ Html.map UpdateIndividualNonBusinessPaymentSummaryMsg individualNonBusinessPaymentSummaryView ]
            ]
    ]

paygIndividualNonBusinessPaymentSummaryView : IndividualNonBusinessPaymentSummary -> Html IndividualNonBusinessPaymentSummaryMsg
paygIndividualNonBusinessPaymentSummaryView individualNBPaymentSummary =
    let
        addrView = addressView individualNBPaymentSummary.address
    in
        div [] [
            h1 [] [ text "Individual Non Business Payment Summary" ],
            ul [] [
                li [] [ inputField "Income Type" UpdatePayeeINBIncomeType ],
                li [] [ inputField "Tax File Number" UpdatePayeeINBTaxFileNumber ],
                li [] [ inputField "First Name" UpdatePayeeINBFirstName ],
                li [] [ inputField "Last Name" UpdatePayeeINBLastName ],
                li [] [ inputField "Second Name" UpdatePayeeINBSecondName ],
                li [] [ inputField "DOB" UpdatePayeeINBDOB ],
                li [] [ Html.map UpdatePayeeINBAddress addrView ],
                li [] [ inputField "Payment Period Start Date" UpdatePayeeINBPaymentPeriodStartDate ],
                li [] [ inputField "Payment Period End Date" UpdatePayeeINBPaymentPeriodEndDate ],
                li [] [ inputField "Total Tax Withheld" UpdatePayeeINBTotalTaxWithheld ],
                li [] [ inputField "Gross Payments" UpdatePayeeINBGrossPayments ],
                li [] [ inputField "Total Allowances" UpdatePayeeINBTotalAllowances ],
                li [] [ inputField "Lump Sum Payment A" UpdatePayeeINBLumpSumPaymentA ],
                li [] [ inputField "Lunp Sum Payment B" UpdatePayeeINBLumpSumPaymentB ],
                li [] [ inputField "Lump Sum Payment C" UpdatePayeeINBLumpSumPaymentC ],
                li [] [ inputField "Lump Sum Payment D" UpdatePayeeINBLumpSumPaymentD ],
                li [] [ inputField "Community Development Employment Project" UpdatePayeeINBCommunityDevEmpProject ],
                li [] [ inputField "Fringe Benefits" UpdatePayeeINBFringeBenefits ],
                li [] [ inputField "Amendment" UpdatePayeeINBAmendment ],
                li [] [ inputField "Employee Super" UpdatePayeeINBEmployeeSuper ],
                li [] [ inputField "Workplace Giving" UpdatePayeeINBWorkplaceGiving ],
                li [] [ inputField "Union Fees" UpdatePayeeINBUnionFees ],
                li [] [ inputField "Exempt Foreign Employment Income" UpdatePayeeINBExemptForeignEmploymentIncome ],
                li [] [ inputField "Deductable Annuity" UpdatePayeeINBDeductableAnnuity ],
                li [] [ inputField "Lump Sum Payment A Type" UpdatePayeeINBLumpSumPaymentAType ]
        ]
    ]

paygSupplierView : PaygSupplier -> Html PaygSupplierMsg
paygSupplierView paygSupplier =
    let
        cdView = contactDetailsView paygSupplier.contactDetails
        supplierBusAddress = addressView paygSupplier.address
        supplierPostalAddress = addressView paygSupplier.postalAddress
    in
        div [] [
            h1 [] [ text "Payg Supplier" ],
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
