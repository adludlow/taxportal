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

addressToPSARRec : Address -> String
addressToPSARRec address =
    let
        streetAddress1 = createPSARFieldRPad address.streetAddress1 38 ' '
        streetAddress2 = createPSARFieldRPad address.streetAddress2 38 ' '
        suburb = createPSARFieldRPad address.suburb 27 ' '
        state = createPSARFieldRPad address.state 3 ' '
        postcode = createPSARFieldRPad address.postcode 4 ' '
        country = createPSARFieldRPad address.country 20 ' '
    in
        concat [
            streetAddress1,
            streetAddress2,
            suburb,
            state,
            postcode,
            country
        ]

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

initPaygSupplier : PaygSupplier
initPaygSupplier =
    PaygSupplier ""
                 ""
                 initContactDetails
                 initAddress
                 ""
                 ""
                 initAddress

type PaygSupplierMsg =
    UpdateSupplierABN String
    | UpdateSupplierBusinessName String
    | UpdateSupplierContactDetails ContactDetailsMsg
    | UpdateSupplierBusinessAddress AddressMsg
    | UpdateSupplierReportEndDate String
    | UpdateSupplierFileReference String
    | UpdateSupplierPostalAddress AddressMsg


paygSupplierToPSARRec : PaygSupplier -> String
paygSupplierToPSARRec paygSupplier =
    let
        -- Supplier record 1
        suppIdRec1 = initPSARRec "628" "IDENTREGISTER1"
        suppAbn = createPSARFieldRPad paygSupplier.abn 11 ' '
        runType = "P"
        reportEndDate = createPSARFieldRPad paygSupplier.reportEndDate 8 ' '
        dataType = "E"
        reportType = "A"
        formatOfReturnMedia = "P"
        reportSpecVersionNum = "FEMPA011.0"
        suppRec1Filler = createPSARFieldRPad "" 578 ' '

        -- Supplier record 2
        suppIdRec2 = initPSARRec "628" "IDENTREGISTER2"
        busName = createPSARFieldRPad paygSupplier.businessName 200 ' '
        suppCdName = createPSARFieldRPad paygSupplier.contactDetails.name 38 ' '
        suppCdPhone = createPSARFieldRPad paygSupplier.contactDetails.phoneNumber 15 ' '
        suppCdFax = createPSARFieldRPad paygSupplier.contactDetails.faxNumber 15 ' '
        fileRef = createPSARFieldRPad paygSupplier.fileReference 16 ' '
        suppRec2Filler = createPSARFieldRPad "" 327 ' '

        -- Supplier record 3
        suppIdRec3 = initPSARRec "628" "IDENTREGISTER3"
        -- email
        suppEmail = createPSARFieldRPad paygSupplier.contactDetails.emailAddress 76 ' '
        suppRec3Filler = createPSARFieldRPad "" 275 ' '

    in
        (concat [suppIdRec1,
                 suppAbn,
                 runType,
                 reportEndDate,
                 dataType,
                 reportType,
                 formatOfReturnMedia,
                 reportSpecVersionNum,
                 suppRec1Filler,
                 suppIdRec2,
                 busName,
                 suppCdName,
                 suppCdPhone,
                 suppCdFax,
                 fileRef,
                 suppRec2Filler,
                 suppIdRec3,
                 addressToPSARRec paygSupplier.address,
                 addressToPSARRec paygSupplier.postalAddress,
                 suppEmail,
                 suppRec3Filler])

type alias PaygPayer = {
    abn : String,
    branchNumber : String,
    businessName : String,
    address : Address,
    contactDetails : ContactDetails,
    tradingName : String,
    financialYear : String,
    payees : List PaygPayee
}

paygPayerToPSARRec : PaygPayer -> String
paygPayerToPSARRec paygPayer =
    let
        payerRec = initPSARRec "628" "IDENTITY"
        payerAbn = createPSARFieldRPad paygPayer.abn 11 ' '
        payerBranchNumber = createPSARFieldLPad paygPayer.branchNumber 3 '0'
        payerFinancialYear = paygPayer.financialYear
        payerBusinessName = createPSARFieldRPad paygPayer.businessName 200 ' '
        payerTradingName = createPSARFieldRPad paygPayer.tradingName 200 ' '
        payerCDName = createPSARFieldRPad paygPayer.contactDetails.name 38 ' '
        payerCDPhoneNumber = createPSARFieldRPad paygPayer.contactDetails.phoneNumber 15 ' '
        payerCDFax = createPSARFieldRPad paygPayer.contactDetails.faxNumber 15 ' '
    in
        concat [
            payerRec,
            payerAbn,
            payerBranchNumber,
            payerFinancialYear,
            payerBusinessName,
            payerTradingName,
            addressToPSARRec paygPayer.address,
            payerCDName,
            payerCDPhoneNumber,
            payerCDFax,
            createPSARFieldRPad "" 1 ' '
        ]

initPaygPayer : PaygPayer
initPaygPayer =
    PaygPayer ""
              ""
              ""
              initAddress
              initContactDetails
              ""
              ""
              []

type PaygPayerMsg =
    UpdatePayerABN String
    | UpdatePayerBranchNumber String
    | UpdatePayerBusinessName String
    | UpdatePayerTradingName String
    | UpdatePayerAddress AddressMsg
    | UpdatePayerContactDetails ContactDetailsMsg
    | UpdatePayerFinancialYear String

type alias IndividualNonBusinessPaymentSummary = {
    incomeType: String,
    paymentPeriodStartDate: String,
    paymentPeriodEndDate: String,
    totalTaxWithheld: String,
    grossPayments: String,
    totalAllowances: String,
    lumpSumPaymentA: String,
    lumpSumPaymentB: String,
    lumpSumPaymentC: String,
    lumpSumPaymentD: String,
    communityDevelopmentEmploymentProject: String,
    fringeBenefits: String,
    amendment: String,
    employeeSuper: String,
    workplaceGiving: String,
    unionFees: String,
    exemptForeignEmploymentIncome: String,
    deductableAnnuity: String,
    lumpSumPaymentAType: String
}

initIndividualNonBusinessPaymentSummary: IndividualNonBusinessPaymentSummary
initIndividualNonBusinessPaymentSummary =
    IndividualNonBusinessPaymentSummary ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""
                                        ""

type alias PaygPayee = {
    taxFileNumber: String,
    firstName: String,
    lastName: String,
    secondName: String,
    dob: String,
    address: Address,
    individualNonBusinessPaymentSummary: IndividualNonBusinessPaymentSummary
}

initPaygPayee: PaygPayee
initPaygPayee =
    PaygPayee ""
              ""
              ""
              ""
              ""
              initAddress
              initIndividualNonBusinessPaymentSummary

type PaygPayeeMsg =
    UpdatePayeeTaxFileNumber String
    | UpdatePayeeFirstName String
    | UpdatePayeeLastName String
    | UpdatePayeeSecondName String
    | UpdatePayeeDOB String
    | UpdatePayeeAddress AddressMsg
    | UpdateIndividualNonBusinessPaymentSummaryMsg IndividualNonBusinessPaymentSummaryMsg

type IndividualNonBusinessPaymentSummaryMsg =
    UpdatePayeeINBIncomeType String
    | UpdatePayeeINBPaymentPeriodStartDate String
    | UpdatePayeeINBPaymentPeriodEndDate String
    | UpdatePayeeINBTotalTaxWithheld String
    | UpdatePayeeINBGrossPayments String
    | UpdatePayeeINBTotalAllowances String
    | UpdatePayeeINBLumpSumPaymentA String
    | UpdatePayeeINBLumpSumPaymentB String
    | UpdatePayeeINBLumpSumPaymentC String
    | UpdatePayeeINBLumpSumPaymentD String
    | UpdatePayeeINBCommunityDevEmpProject String
    | UpdatePayeeINBFringeBenefits String
    | UpdatePayeeINBAmendment String
    | UpdatePayeeINBEmployeeSuper String
    | UpdatePayeeINBWorkplaceGiving String
    | UpdatePayeeINBUnionFees String
    | UpdatePayeeINBExemptForeignEmploymentIncome String
    | UpdatePayeeINBDeductableAnnuity String
    | UpdatePayeeINBLumpSumPaymentAType String

type alias PaygSummary = {
    paygSupplier : PaygSupplier,
    paygPayer : PaygPayer
}

paygSummaryToPSARString : PaygSummary -> String
paygSummaryToPSARString paygSummary =
    concat [
            paygSupplierToPSARRec paygSummary.paygSupplier,
            paygPayerToPSARRec paygSummary.paygPayer
           ]

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
                initPaygPayer


type Msg =
    PaygSummaryMsg PaygSummaryMsg
    | SubmitPaygSummaryMsg

type PaygSummaryMsg =
    PaygSupplierMsg PaygSupplierMsg
    | PaygPayerMsg PaygPayerMsg


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

