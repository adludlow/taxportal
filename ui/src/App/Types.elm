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
    inb : IndividualNonBusinessPaymentSummary
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
            createPSARFieldRPad "" 1 ' ',
            individualNonBusinessSummaryToPSARRec paygPayer.inb
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
              initIndividualNonBusinessPaymentSummary

type PaygPayerMsg =
    UpdatePayerABN String
    | UpdatePayerBranchNumber String
    | UpdatePayerBusinessName String
    | UpdatePayerTradingName String
    | UpdatePayerAddress AddressMsg
    | UpdatePayerContactDetails ContactDetailsMsg
    | UpdatePayerFinancialYear String
    | UpdateINBMsg IndividualNonBusinessPaymentSummaryMsg

type alias IndividualNonBusinessPaymentSummary = {
    incomeType: String,
    taxFileNumber: String,
    firstName: String,
    lastName: String,
    secondName: String,
    dob: String,
    address: Address,
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
                                        initAddress
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

individualNonBusinessSummaryToPSARRec : IndividualNonBusinessPaymentSummary -> String
individualNonBusinessSummaryToPSARRec inb =
    let
        inbHeader = initPSARRec "628" "DINB"
        inbIncomeType = createPSARFieldRPad inb.incomeType 3 ' '
        inbTaxFileNumber = createPSARFieldRPad inb.taxFileNumber 9 ' '
        inbDOB = createPSARFieldRPad inb.dob 8 ' '
        inbLastName = createPSARFieldRPad inb.lastName 30 ' '
        inbFirstName = createPSARFieldRPad inb.firstName 15 ' '
        inbSecondName = createPSARFieldRPad inb.secondName 15 ' '
        inbAddress = addressToPSARRec inb.address
        inbPaymentPeriodStartDate = createPSARFieldRPad inb.paymentPeriodStartDate 8 ' '
        inbPaymentPeriodEndDate = createPSARFieldRPad inb.paymentPeriodEndDate 8 ' '
        inbTotalTaxWithheld = createPSARFieldLPad inb.totalTaxWithheld 8 '0'
        inbGrossPayments = createPSARFieldRPad inb.grossPayments 8 '0'
        inbTotalAllowances = createPSARFieldLPad inb.totalAllowances 8 '0'
        inbLumpSumPaymentA = createPSARFieldLPad inb.lumpSumPaymentA 8 '0'
        inbLumpSumPaymentB = createPSARFieldLPad inb.lumpSumPaymentB 8 '0'
        inbLumpSumPaymentC = createPSARFieldLPad inb.lumpSumPaymentC 8 '0'
        inbLumpSumPaymentD = createPSARFieldLPad inb.lumpSumPaymentD 8 '0'
        inbCommunityDevelopmentEmploymentProject = createPSARFieldLPad inb.communityDevelopmentEmploymentProject 8 '0'
        zeroFiller1 = createPSARFieldLPad "" 8 '0'
        inbFringeBenefits = createPSARFieldLPad inb.fringeBenefits 8 '0'
        inbAmendment = "O"
        inbEmployeeSuper = createPSARFieldLPad inb.employeeSuper 8 '0'
        inbLumpSumPaymentAType = " "
        inbWorkplaceGiving = createPSARFieldLPad inb.workplaceGiving 8 '0'
        inbUnionFees = createPSARFieldLPad inb.unionFees 8 '0'
        inbExemptForeignIncome = createPSARFieldLPad inb.exemptForeignEmploymentIncome 8 '0'
        inbDeductableAnnuity = createPSARFieldLPad inb.deductableAnnuity 8 '0'
    in
        concat [
            inbHeader,
            inbIncomeType,
            inbTaxFileNumber,
            inbDOB,
            inbLastName,
            inbFirstName,
            inbSecondName,
            inbAddress,
            inbPaymentPeriodStartDate,
            inbPaymentPeriodEndDate,
            inbTotalTaxWithheld,
            inbGrossPayments,
            inbTotalAllowances,
            inbLumpSumPaymentA,
            inbLumpSumPaymentB,
            inbLumpSumPaymentC,
            inbLumpSumPaymentD,
            inbCommunityDevelopmentEmploymentProject,
            zeroFiller1,
            inbFringeBenefits,
            inbAmendment,
            inbEmployeeSuper,
            inbLumpSumPaymentAType,
            inbWorkplaceGiving,
            inbUnionFees,
            inbExemptForeignIncome,
            inbDeductableAnnuity,
            createPSARFieldRPad "" 275 ' '
        ]

type alias PaygPayee = {
    taxFileNumber: String,
    firstName: String,
    lastName: String,
    secondName: String,
    dob: String,
    address: Address,
    inb : IndividualNonBusinessPaymentSummary
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
    | UpdatePayeeINBTaxFileNumber String
    | UpdatePayeeINBFirstName String
    | UpdatePayeeINBLastName String
    | UpdatePayeeINBSecondName String
    | UpdatePayeeINBDOB String
    | UpdatePayeeINBAddress AddressMsg
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

