module App.Types exposing (..)

import String exposing (concat, length, padLeft, padRight)

type alias ContactDetails = {
    name : String,
    emailAddress : String,
    phoneNumber : String,
    faxNumber : String
}

type ContactDetailsMsg =
    UpdateCDName String
    | UpdateCDEmailAddress String
    | UpdateCDPhoneNumber String
    | UpdateCDFaxNumber String

initContactDetails : ContactDetails
initContactDetails =
    ContactDetails ""
                   ""
                   ""
                   ""

type alias Address = {
    streetAddress1 : String,
    streetAddress2 : String,
    suburb : String,
    state : String,
    postcode : String,
    country : String
}

type AddressMsg =
    UpdateStreetAddress1 String
    | UpdateStreetAddress2 String
    | UpdateSuburb String
    | UpdateState String
    | UpdatePostcode String
    | UpdateCountry String

initAddress =
    Address ""
            ""
            ""
            ""
            ""
            ""

type alias PaygSupplier = {
    abn : String,
    businessName : String,
    contactDetails : ContactDetails,
    address : Address,
    reportEndDate : String,
    fileReference : String,
    postalAddress : Address
}

paygSupplierToPSARRec : PaygSupplier -> String
paygSupplierToPSARRec paygSupplier =
    let
        suppIdRec1 = initPSARRec "628" "IDENTREGISTER1"
        suppAbn = createPSARFieldRPad paygSupplier.abn 11 ' '
        runType = "P"
        reportEndDate = createPSARFieldRPad paygSupplier.reportEndDate 8 ' '
        dataType = "E"
        reportType = "A"
        formatOfReturnMedia = "P"
        reportSpecVersionNum = "FEMPA011.0"
        filler = createPSARFieldRPad "" 578 ' '
    in
        (concat [suppIdRec1,
                 suppAbn,
                 runType,
                 reportEndDate,
                 dataType,
                 reportType,
                 formatOfReturnMedia,
                 reportSpecVersionNum,
                 filler])

type alias PaygSummary = {
    paygSupplier : PaygSupplier
}



type alias Model = {
    paygSummary : PaygSummary,
    psarString : String
}

initModel : Model
initModel =
    Model initPaygSummary ""

initPaygSummary : PaygSummary
initPaygSummary =
    PaygSummary initPaygSupplier

initPaygSupplier : PaygSupplier
initPaygSupplier =
    PaygSupplier ""
                 ""
                 initContactDetails
                 initAddress
                 ""
                 ""
                 initAddress

type Msg =
    PaygSummaryMsg PaygSummaryMsg
    | SubmitPaygSummaryMsg

type PaygSummaryMsg =
    PaygSupplierMsg PaygSupplierMsg

type PaygSupplierMsg =
    UpdateSupplierABN String
    | UpdateSupplierBusinessName String
    | UpdateSupplierContactDetails ContactDetailsMsg
    | UpdateSupplierBusinessAddress AddressMsg
    | UpdateSupplierReportEndDate String
    | UpdateSupplierFileReference String
    | UpdateSupplierPostalAddress AddressMsg

-- Init and Conversion Functions
initPSARRec : String -> String -> String
initPSARRec recLen recId =
    concat [recLen, recId]

createPSARFieldLPad : String -> Int -> Char -> String
createPSARFieldLPad newField fieldLen lpadVal =
    let
        newFieldLen = length newField
    in
        if newFieldLen < fieldLen then
            padLeft fieldLen lpadVal newField
        else
            newField

createPSARFieldRPad : String -> Int -> Char -> String
createPSARFieldRPad newField fieldLen rpadVal =
    let
        newFieldLen = length newField
    in
        if newFieldLen < fieldLen then
            padRight fieldLen rpadVal newField
        else
            newField

