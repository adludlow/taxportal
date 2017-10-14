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
    paygSummaryToPSARString paygSummary

updatePaygSummary : PaygSummaryMsg -> PaygSummary -> PaygSummary
updatePaygSummary msg paygSummary =
    case msg of
        PaygSupplierMsg paygSupplierMsg ->
            ({paygSummary | paygSupplier = updatePaygSupplier paygSupplierMsg paygSummary.paygSupplier})
        PaygPayerMsg paygPayerMsg ->
            ({paygSummary | paygPayer = updatePaygPayer paygPayerMsg paygSummary.paygPayer})

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

updatePaygPayer : PaygPayerMsg -> PaygPayer -> PaygPayer
updatePaygPayer msg paygPayer =
    case msg of
        UpdatePayerABN abn ->
            ({ paygPayer | abn = abn })
        UpdatePayerBranchNumber branchNumber ->
            ({ paygPayer | branchNumber = branchNumber })
        UpdatePayerBusinessName businessName ->
            ({ paygPayer | businessName = businessName })
        UpdatePayerAddress addressMsg ->
            ({ paygPayer | address = updateAddress addressMsg paygPayer.address })
        UpdatePayerContactDetails contactDetailsMsg ->
            ({ paygPayer | contactDetails = updateContactDetails contactDetailsMsg paygPayer.contactDetails })
        UpdatePayerTradingName tradingName ->
            ({ paygPayer | tradingName = tradingName })
        UpdatePayerFinancialYear financialYear ->
            ({ paygPayer | financialYear = financialYear })
        UpdateINBMsg inbMsg ->
            ({ paygPayer | inb = updateIndividualNonBusinessPaymentSummary inbMsg paygPayer.inb })

updatePaygPayee : PaygPayeeMsg -> PaygPayee -> PaygPayee
updatePaygPayee msg paygPayee =
    case msg of
        UpdatePayeeTaxFileNumber tfn ->
            ({ paygPayee | taxFileNumber = tfn })
        UpdatePayeeFirstName firstName ->
            ({ paygPayee | firstName = firstName })
        UpdatePayeeLastName lastName ->
            ({ paygPayee | lastName = lastName })
        UpdatePayeeSecondName secondName ->
            ({ paygPayee | secondName = secondName })
        UpdatePayeeDOB dob ->
            ({ paygPayee | dob = dob })
        UpdatePayeeAddress addressMsg ->
            ({ paygPayee | address = updateAddress addressMsg paygPayee.address })
        UpdateIndividualNonBusinessPaymentSummaryMsg inbMsg ->
            ({ paygPayee | inb = updateIndividualNonBusinessPaymentSummary inbMsg paygPayee.inb })

updateIndividualNonBusinessPaymentSummary: IndividualNonBusinessPaymentSummaryMsg -> IndividualNonBusinessPaymentSummary -> IndividualNonBusinessPaymentSummary
updateIndividualNonBusinessPaymentSummary msg inb =
    case msg of
        UpdatePayeeINBIncomeType incomeType ->
            ({ inb | incomeType = incomeType })
        UpdatePayeeINBTaxFileNumber tfn ->
            ({ inb  | taxFileNumber = tfn })
        UpdatePayeeINBFirstName firstName ->
            ({ inb | firstName = firstName })
        UpdatePayeeINBLastName lastName ->
            ({ inb | lastName = lastName })
        UpdatePayeeINBSecondName secondName ->
            ({ inb | secondName = secondName })
        UpdatePayeeINBDOB dob ->
            ({ inb | dob = dob })
        UpdatePayeeINBAddress addressMsg ->
            ({ inb | address = updateAddress addressMsg inb.address })
        UpdatePayeeINBPaymentPeriodStartDate payPeriodStartDate ->
            ({ inb | paymentPeriodStartDate = payPeriodStartDate })
        UpdatePayeeINBPaymentPeriodEndDate payPeriodEndDate ->
            ({ inb | paymentPeriodEndDate = payPeriodEndDate })
        UpdatePayeeINBTotalTaxWithheld totTaxWithheld ->
            ({ inb | totalTaxWithheld = totTaxWithheld })
        UpdatePayeeINBGrossPayments grossPayments ->
            ({ inb | grossPayments  = grossPayments })
        UpdatePayeeINBTotalAllowances totalAllowances ->
            ({ inb | totalAllowances = totalAllowances })
        UpdatePayeeINBLumpSumPaymentA lumpSumPaymentA ->
            ({ inb | lumpSumPaymentA = lumpSumPaymentA })
        UpdatePayeeINBLumpSumPaymentB lumpSumPaymentB ->
            ({ inb | lumpSumPaymentB = lumpSumPaymentB })
        UpdatePayeeINBLumpSumPaymentC lumpSumPaymentC ->
            ({ inb | lumpSumPaymentC = lumpSumPaymentC })
        UpdatePayeeINBLumpSumPaymentD lumpSumPaymentD ->
            ({ inb | lumpSumPaymentD = lumpSumPaymentD })
        UpdatePayeeINBCommunityDevEmpProject commDevEmpProject ->
            ({ inb | communityDevelopmentEmploymentProject = commDevEmpProject })
        UpdatePayeeINBFringeBenefits fringeBenefits ->
            ({ inb | fringeBenefits = fringeBenefits })
        UpdatePayeeINBAmendment amendment ->
            ({ inb | amendment = amendment })
        UpdatePayeeINBEmployeeSuper employeeSuper ->
            ({ inb | employeeSuper = employeeSuper })
        UpdatePayeeINBWorkplaceGiving workplaceGiving ->
            ({ inb | workplaceGiving = workplaceGiving })
        UpdatePayeeINBUnionFees unionFees ->
            ({ inb | unionFees = unionFees })
        UpdatePayeeINBExemptForeignEmploymentIncome foreignEmploymentIncome ->
            ({ inb | exemptForeignEmploymentIncome = foreignEmploymentIncome })
        UpdatePayeeINBDeductableAnnuity deductableAnnuity ->
            ({ inb | deductableAnnuity = deductableAnnuity })
        UpdatePayeeINBLumpSumPaymentAType lumpSumPaymentAType ->
            ({ inb | lumpSumPaymentAType = lumpSumPaymentAType })

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
