/******************************************************************************************************************
* Author: Samar Saha
* Date: Oct - 2019
* Update History - 
*****************************************************************************************************************/ 
public class INV_DM_TestHelper {
    public static loan__Loan_Product__c createLoanProduct(
                                       String name,
                                       loan__Office_Name__c dummyOffice,
                                       loan__MF_Account__c dummyAcccount,
                                       loan__Currency__c curr,
                                       loan__Fee_Set__c dummyFeeSet,
                                       String productType) {
        Id prodRTId = Schema.SObjectType.loan__Loan_Product__c.getRecordTypeInfosByName().get('Loan Product Record Type').getRecordTypeId();
        
        loan__Loan_Product__c dummyLP = new loan__Loan_Product__c(Name=name,
            loan__Loan_Product_Type__c = productType,
            loan__Currency__c = (curr != null) ? curr.ID : null,
            loan__Fee_Set__c = (dummyFeeSet != null) ? dummyFeeSet.ID : null,
            loan__Accrual_Based_Accounting__c=true,
            loan__Accrue_Income_On_Suspended_Account__c=true,
            loan__Cash_Based_Accounting__c=false,
            loan__Maximum_Gap_Between_Installments__c=1,
            loan__Minimum_Gap_Between_Installments__c=1,
            loan__Max_Loan_Amount__c=30000,
            loan__Max_Overdue_Interest_Rate__c=24,
            loan__Minimum_Installment_Amount__c=100,
            loan__Min_Interest_Rate__c=1,
            loan__Min_Loan_Amount__c=0,
            loan__Min_Number_of_Installments__c=0,
            loan__Min_Overdue_Interest_Rate__c=10,
            loan__Product_Interest_Income_Account__c=dummyAcccount.Id,
            loan__Product_Int_On_Overdue_Income_Acc__c=dummyAcccount.Id,
            loan__Product_Loan_Control_Account__c=dummyAcccount.Id,
            loan__Product_Loan_Loss_Provision_Account__c=dummyAcccount.Id,
            loan__Product_Loan_Loss_Reserve_Account__c=dummyAcccount.Id,
            loan__Product_Overdue_Interest_Account__c=dummyAcccount.Id,
            loan__Product_Suspended_Interest_Account__c=dummyAcccount.Id,
            loan__Product_Suspended_Int_On_Overdue_Acc__c=dummyAcccount.Id,
            loan__Product_Write_Off_Recovery_Account__c=dummyAcccount.Id,
            loan__Product_Interest_Amortization_Account__c=dummyAcccount.Id,
            loan__Product_Excess_Account__c=dummyAcccount.Id,
            loan__Status__c='Active',
            recordTypeId=prodRTId
        );
            return dummyLP;
        }
    
        public static DM_Loan_Account__c createDMLOC(loan__Loan_Product__c dummyLP,
                                                         Decimal creditLimit,
                                                         Account dummyAccount,
                                                         loan__Fee_Set__c dummyFeeSet,
                                                         loan__Office_name__c dummyOffice,
                                                         Integer term,
                                                         String interestCalcMethod
                                                         ) {
            DM_Loan_Account__c loanAccount = new DM_Loan_Account__c();
            loanAccount.DM_Product_Type__c = 'Simple Loan';
            loanAccount.DM_Loan_Amount__c = 0;
            loanAccount.DM_Credit_Limit__c = creditLimit;
            loanAccount.DM_Credit_Limit_Current__c = creditLimit;
            loanAccount.migration_Status__C='Pending';   
            loanAccount.DM_Account__c= dummyAccount.Id; 
            if(dummyLP.Name =='Simple Loan'){                                                 
                loanAccount.Batch_Type__c='Simple Loan'; 
                loanAccount.dm_custom_field_1__c = '12-12-2018';
                if(interestCalcMethod =='Error'){ 
                  system.debug('Calc name error');
                  loanAccount.Batch_Type__c='Error';
              } 
            }    
            else if(dummyLP.Name =='Difficult Loan'){ 
                loanAccount.Batch_Type__c='Difficult Loan';
                loanAccount.dm_custom_field_1__c = 'True';
            }  
            loanAccount.DM_Number_of_Installments__c = term;
            loanAccount.DM_Contractual_Interest_Rate__c = loanAccount.DM_Interest_Rate__c;
            loanAccount.DM_Fee_Set__c = (dummyFeeSet != null) ? dummyFeeSet.ID : null;
            loanAccount.DM_Product__c = dummyLP.ID;
            loanAccount.DM_Overdue_Interest_Rate__c = 12;
            loanAccount.DM_Expected_Disbursal_Date__c = Date.today().addDays(-20);
            loanAccount.DM_Repayment_Tied_to_Meeting_Schedule__c = false;
            loanAccount.DM_Repayment_Procedure__c = 'Equal Monthly Installments';
            loanAccount.DM_Interest_Calculation_Method__c = interestCalcMethod;
            loanAccount.DM_Time_Counting_Method__c = 'Actual Days';
            loanAccount.DM_Expected_Repayment_Start_Date__c = Date.today().addDays(-5);
            loanAccount.DM_Branch__c = dummyOffice.ID;
            loanAccount.DM_Oldest_Due_Date__c = loanAccount.DM_Expected_Repayment_Start_Date__c;
            loanAccount.DM_First_Installment_Date__c = loanAccount.DM_Expected_Repayment_Start_Date__c;
            loanAccount.DM_Next_Installment_Date__c = loanAccount.DM_First_Installment_Date__c;
            loanAccount.DM_Disbursal_Date__c = loanAccount.DM_Expected_Disbursal_Date__c;
            loanAccount.DM_Term_Cur__c = loanAccount.DM_Number_of_Installments__c;
            loanAccount.DM_Principal_Remaining__c = 0;
            Integer dueday = loanAccount.DM_First_Installment_Date__c.day();
            loanAccount.DM_Due_Day__c = dueday;
            loanAccount.DM_Contractual_Due_Day__c = dueday;
            loanAccount.DM_Interest_Only_Period__c = 0;
            loanAccount.DM_Interest_Only_Payment_Amt__c = 0;
            loanAccount.DM_Valid_Data__c = True;
            loanAccount.DM_Grace_Period_for_Repayments__c = 10;
            loanAccount.DM_Delinquency_Grace_Days__c = 10;
            loanAccount.DM_Pre_Bill_Days__c = 10;
            return loanAccount;
    }//END createDMLOC
    
    public static DM_Loan_Disbursal_Transaction__c fundLoan(DM_Loan_Account__c loanAccount,
                                                         Date currentSystemDate,
                                                         loan__Payment_Mode__c pmode,
                                                         loan__Bank_Account__c bankAccount
                                                        ) {

        DM_Loan_Disbursal_Transaction__c disbTxn = new DM_Loan_Disbursal_Transaction__c();
        disbTxn.DM_Disbursal_Date__c = currentSystemDate;
        disbTxn.DM_Disbursed_Amt__c = loanAccount.DM_Loan_Amount__c;
        disbTxn.DM_CL_Contract__c = loanAccount.id;
        disbTxn.DM_Mode_of_Payment__c =  pMode.id;
        disbTxn.DM_bank_Account__c = bankAccount.id;
                                                            
        return disbTxn;
    }//END fundLoan
    
    public static DM_Automated_Payment_Setup__c createAutomatedPaymentSetup(String type,
                                                                          String amountType,
                                                                          loan__Bank_Account__c bank,
                                                                          DM_Loan_Account__c lAcc,
                                                                          String frequency,
                                                                          loan__Payment_Mode__c pMode,
                                                                          Date debitDate,
                                                                          Integer debitDay) {
        DM_Automated_Payment_Setup__c automatedPaymentSetup = new DM_Automated_Payment_Setup__c();
        automatedPaymentSetup.DM_Active__c = true;
        automatedPaymentSetup.DM_Amount_Type__c = amountType;
        automatedPaymentSetup.DM_Bank_Account__c = bank.id;
        automatedPaymentSetup.DM_CL_Contract__C = lAcc.Id;
        automatedPaymentSetup.DM_Frequency__c = frequency;
        automatedPaymentSetup.DM_Payment_Mode__c = pMode.Id;
        automatedPaymentSetup.DM_Recurring_ACH_End_Date__c = debitDate.addDays(180);
        automatedPaymentSetup.DM_Type__c = type;
        automatedPaymentSetup.DM_Recurring_ACH_Start_Date__c = debitDate;
        automatedPaymentSetup.DM_Debit_Date__c = debitDate;
        
        return automatedPaymentSetup;
    }
    
    public static DM_Bill__c createUnpaidDue(DM_Loan_Account__c loanAccount, Decimal dueAmount) {
        DM_Bill__c due = new DM_Bill__c(DM_CL_Contract__c = loanAccount.Id,
                                        DM_Due_Amt__c = dueAmount,
                                        DM_Due_Date__c = Date.Today(),
                                        DM_Due_Type_Description__c = 'BILL',
                                        DM_Due_Type__c = 1);
        return due;
    }//END createUnpaidDue
    
    public static DM_Charge__c createUnpaidCharge(DM_Loan_Account__c loanAccount, loan__Fee__c fee, Decimal chargeAmount) {
        DM_Charge__c charge = new DM_Charge__c(DM_CL_Contract__c = loanAccount.Id,
                                            DM_Original_Amount__c = chargeAmount,
                                            DM_Date__c = Date.Today(),
                                            DM_Calculated_Interest3__c = chargeAmount,
                                            DM_Fee__c = fee.Id);
        return charge;
    }//END createUnpaidCharge
    
     public static DM_Loan_Payment_Transaction__c createLoanPayment(Id lAccountId,
                                                            Decimal transactionAmount,
                                                            Date transDate,
                                                            DM_Automated_Payment_Setup__c aPS,
                                                            loan__Payment_Mode__c pMode,
                                                            Date retryOn) {
        DM_Loan_Payment_Transaction__c payment = new DM_Loan_Payment_Transaction__c();
        payment.DM_Transaction_Date__c = transDate;
        payment.DM_Transaction_Amount__c = transactionAmount;
        payment.CL_Contract__c = lAccountId;
        payment.DM_Receipt_Date__c= Date.today();                                                       
        payment.DM_Skip_Validation__c = true;
        payment.DM_Interest__c = 10.00;
        if (aPS != null){
            payment.DM_Automated_Payment_Setup__c = aPS.Id;
            //payment.DM_Payment_Mode__c = aPS.Payment_Mode__c;
        }
        return payment;
    }//END createLoanPaymentWithoutCommit
  
    public static DM_Repayment_Schedule_Summary__c CreateRSSData(DM_Loan_Account__c loanAccount,Decimal Amount) {
        DM_Repayment_Schedule_Summary__c rss = new DM_Repayment_Schedule_Summary__c();
        rss.DM_RSS_No_Of_Pmts__c = 1;
        rss.DM_RSS_Repayment_Amt__c = amount;
        rss.DM_CL_Contract__c = loanAccount.id;
        rss.DM_RSS_Repayment_Dt__c =  Date.today().addDays(-1);
        rss.DM_RSS_Seq__c = 1;
        return rss;
    }//END CreateRSSData
    
    public static DM_Repayment_Schedule__c CreateAmzScheduleData(DM_Loan_Account__c loanAccount,Decimal Amount ) {
        DM_Repayment_Schedule__c repaySch = new DM_Repayment_Schedule__c();
        repaySch.DM_Loan_Product__c = loanAccount.Id;
        repaySch.DM_Due_Date__c = Date.Today().addDays(30);
        repaySch.DM_Due_Interest__c = 40.00 ;
        repaySch.DM_Balance__c = 800;
        repaySch.DM_Paid_Principal__c=amount;                                              
        return repaySch;                                                
    }//END CreateAmzScheduleData                                                    
}//END DM_TestHelper