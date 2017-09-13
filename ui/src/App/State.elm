module App.State exposing (..)

import App.Types exposing (..)

initialState : (Model, Cmd Msg)
initialState = (initModel, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        PaygSummaryMsg paygSummaryMsg ->
            ({model | paygSummary = updatePaygSummary paygSummaryMsg model.paygSummary}, Cmd.none)
        SubmitPaygSummaryMsg ->
            ({model | psarString = (createPSARString model.paygSummary)}, Cmd.none)

createPSARString : PaygSummary -> String
createPSARString paygSummary =
    paygSupplierToPSARRec paygSummary.paygSupplier

updatePaygSummary : PaygSummaryMsg -> PaygSummary -> PaygSummary
updatePaygSummary msg paygSummary =
    case msg of
        PaygSupplierMsg paygSupplierMsg ->
            ({paygSummary | paygSupplier = updatePaygSupplier paygSupplierMsg paygSummary.paygSupplier})

updatePaygSupplier : PaygSupplierMsg -> PaygSupplier -> PaygSupplier
updatePaygSupplier msg paygSupplier =
    case msg of
        UpdateSupplierABN abn ->
            ({ paygSupplier | abn = abn})
        UpdateSupplierBusinessName businessName ->
            ({ paygSupplier | businessName = businessName})
        UpdateSupplierReportEndDate endDate ->
            ({ paygSupplier | reportEndDate = endDate})
        UpdateSupplierFileReference fileReference ->
            ({ paygSupplier | fileReference = fileReference})
        UpdateSupplierContactDetails contactDetailsMsg ->
            ({ paygSupplier | contactDetails = updateContactDetails contactDetailsMsg paygSupplier.contactDetails})
        UpdateSupplierBusinessAddress addressMsg ->
            ({ paygSupplier | address = updateAddress addressMsg paygSupplier.address })
        UpdateSupplierPostalAddress postalAddressMsg ->
            ({ paygSupplier | postalAddress = updateAddress postalAddressMsg paygSupplier.postalAddress })

updateContactDetails : ContactDetailsMsg -> ContactDetails -> ContactDetails
updateContactDetails msg contactDetails =
    case msg of
        UpdateCDName name ->
            ({ contactDetails | name = name })
        UpdateCDEmailAddress emailAddress ->
            ({ contactDetails | emailAddress = emailAddress })
        UpdateCDPhoneNumber phoneNumber ->
            ({ contactDetails | phoneNumber = phoneNumber })
        UpdateCDFaxNumber faxNumber ->
            ({ contactDetails | faxNumber = faxNumber})

updateAddress : AddressMsg -> Address -> Address
updateAddress msg address =
    case msg of
        UpdateStreetAddress1 streetAddress1 ->
            ({ address | streetAddress1 = streetAddress1 })
        UpdateStreetAddress2 streetAddress2 ->
            ({ address | streetAddress2 = streetAddress2 })
        UpdateSuburb suburb ->
            ({ address | suburb = suburb })
        UpdatePostcode postcode ->
            ({ address | postcode = postcode })
        UpdateState state ->
            ({ address | state = state })
        UpdateCountry country ->
            ({ address | country = country })

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
