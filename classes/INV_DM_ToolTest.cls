/******************************************************************************************************************
* Author: Samar Saha
* Date: Oct - 2019
* Update History - 
*****************************************************************************************************************/ 
@isTest
public class INV_DM_ToolTest{
    @testSetup
    static void testData(){
        loan__Org_Parameters__c orgParam = new loan__Org_Parameters__c();
        orgParam.loan__Disable_Triggers__c=true;
        orgParam.loan__Digits_After_Decimals__c=2;
        orgParam.loan__Rounding_Mode__c='Nearest';
        insert orgParam;
        
        loan__Trigger_Parameters__c triggerParam = new loan__Trigger_Parameters__c();
        triggerParam.loan__Disable_Loan_Account_Trigger__c=true;
        insert triggerParam;
        
        loan.TestHelper.createSeedDataForTesting();
        loan.TestHelper.setupApprovalProcessForTxn();  
        //Account a2 = loan.TestHelper2.createInvestor('Bull', 1000); 
        loan.CustomSettingsUtil.getNS();
        //Create Borrower 
        Account b1 = loan.TestHelper2.createBorrower('ShoeString'); 
        loan.TestHelper.systemDate = Date.today(); 
        Id rtId = Schema.SObjectType.loan__Office_Name__c.getRecordTypeInfosByName().get('Root Branch').getRecordTypeId();
        Id prodRTId = Schema.SObjectType.loan__Loan_Product__c.getRecordTypeInfosByName().get('Loan Product Record Type').getRecordTypeId();

        loan__Currency__c curr = loan.TestHelper.createCurrency();
        loan__office_Type__c testBranchType = new loan__Office_Type__c(Name='Data Migration',
                                                        loan__Office_Type_Short_Code__c='TestSC' );
        insert testBranchType;
                                                               
        loan__MF_Account__c a1 = loan.TestHelper.createMFAccount('TestAccountForOffice', '10000 - ASSETS');
    
        loan__Branch_Location__c testLoc = new loan__Branch_Location__c(Name='Data Migration',
                                            loan__Address_Line_1__c = 'Add1',
                                            loan__Address_Line_2__c = 'Add2',
                                            loan__State__c = 'MH',
                                            loan__Phone__C = '32323232',
                                            loan__Zip_code__c = 33333
                                            );
        insert testLoc;
        
        loan__Office_Name__c dummyOffice = new loan__Office_Name__c(Name='Data Migration',
                                                    loan__Office_Location__c = testLoc.ID,
                                                    loan__Office_Short_Name__c = 'XXXCSN',
                                                    loan__Cash_Account__c = a1.Id,
                                                    loan__Check_Account__c = a1.Id,
                                                    loan__Bank_Account_Checks__c = a1.Id,
                                                    loan__Inward_Check_Clearance_Account__c = a1.Id,
                                                    loan__Outward_Check_Clearance_Account__c= a1.Id,
                                                    loan__Profit_and_Loss_Account__c = a1.Id,
                                                    loan__Loan_Schedule_tied_to_Meeting_Schedule__c = false,
                                                    loan__Mark_Suspended_After_Days__c = 180,
                                                    loan__State__c = 'Active',
                                                    loan__Write_Off_Suggestion_Days__c = 90,
                                                    loan__Office_Type__c = testBranchType.ID,
                                                    loan__Days_in_advance_to_create_Collection_Rep__c=1,
                                                    loan__Current_System_Date__c = Date.Today().addDays(-30),
                                                    RecordTypeId = rtId,
                                                    loan__Is_Branch__c=true);
        insert dummyOffice;
                
        loan__MF_Account__c dummyIncAccount = loan.TestHelper.createMFAccount('XXXIncAccountForTest', '30000 - INCOME');
        loan__MF_Account__c dummyAccount = loan.TestHelper.createMFAccount('XXXAccountForTest', '10000 - ASSETS');
        loan__Fee__c dummyFee = loan.TestHelper.createFee(curr, dummyIncAccount, dummyAccount); 
        loan__Fee_Set__c dummyFeeSet = loan.TestHelper.createFeeSet(); 
        loan__Fee_Junction__c dummyFeeJunction = loan.TestHelper.createFeeJunction(dummyFee, dummyFeeSet);
        List<loan__Loan_Product__c> loanProductList = new List<loan__Loan_Product__c>();
        loan__Loan_Product__c simpleLP = INV_DM_TestHelper.createLoanProduct('Simple Loan',dummyOffice, 
                                              dummyAccount, curr, dummyFeeSet, 'Loan'); 
        loanProductList.add(simpleLP);
        
        loan__Loan_Product__c difficultLP = INV_DM_TestHelper.createLoanProduct('Difficult Loan',dummyOffice, 
                                              dummyAccount, curr, dummyFeeSet, 'Loan');
        loanProductList.add(difficultLP);
        
        loan__Loan_Product__c errorLp = INV_DM_TestHelper.createLoanProduct('Simple Loan',dummyOffice, 
                                              dummyAccount, curr, dummyFeeSet, 'Loan');
        loanProductList.add(errorLp);
        
        insert loanProductList;
                     
        loan__Payment_Mode__c pMode = new loan__Payment_Mode__c(name='Cash');
       // insert pMode;
        
        loan__Bank_Account__c bankAccount = new loan__Bank_Account__c(loan__Bank_Account_Number__c = '12345678', 
                                                 loan__Bank_Name__c = 'Some Bank', 
                                                 loan__Routing_Number__c = '99999999', 
                                                 loan__Account_Type__c = 'Savings', 
                                                 loan__Account_Usage__c = 'Borrower/Investor Account', 
                                                 loan__Account__c = b1.id);
        insert bankAccount;
        
        List<DM_Loan_Account__c> dmLoanList = new List<DM_Loan_Account__c>();
        DM_Loan_Account__c dmloan = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        //dmloan.DM_Valid_Data__c = False;
        dmLoanList.add(dmloan);
        
        DM_Loan_Account__c dmloan2 = INV_DM_TestHelper.createDMLOC(difficultLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmLoanList.add(dmloan2);
        
        DM_Loan_Account__c dmloan3 = INV_DM_TestHelper.createDMLOC(errorLp,0.0,b1,dummyFeeSet,dummyOffice,5,'Error');
        dmLoanList.add(dmloan3);
        insert dmLoanList;
        
        DM_Loan_Disbursal_Transaction__c ldt =  INV_DM_TestHelper.fundLoan(dmLoan, Date.Today(), pmode,bankAccount);
        insert ldt;
                                                        
        DM_Bill__c bill =  INV_DM_TestHelper.createUnpaidDue(dmLoan, 6500.00);
        insert bill;
        
        DM_Repayment_Schedule_Summary__c dm_RSS = INV_DM_TestHelper.CreateRSSData(dmLoan, 600.00);
        insert dm_RSS;
        
        DM_Charge__c charge =  INV_DM_TestHelper.createUnpaidCharge(dmLoan, dummyFee, 100.00 );
        insert charge;
        
        DM_Repayment_Schedule__c AmzSchedule = INV_DM_TestHelper.CreateAmzScheduleData(dmLoan, 1000.00);
        insert AmzSchedule;
        
        DM_Automated_Payment_Setup__c aps =  INV_DM_TestHelper.createAutomatedPaymentSetup('DO it later', '', bankAccount,
                                                         dmLoan, '', pMode, Date.Today(),1);
        insert aps;
        
        DM_Loan_Payment_Transaction__c lpt = INV_DM_TestHelper.createLoanPayment(dmLoan.Id, 10000.00,Date.today(),aPS, pMode, null);
        insert lpt;
    }//END testData
    
    
    @isTest
    static void testMigrationJob(){ 
            //List<DM_Loan_Account__c> dmList = [select id from DM_Loan_Account__c];
            Test.startTest();
            INV_DM_MigrationJob dm = new INV_Dm_MigrationJob();
            Database.executeBatch(dm);
            Test.stopTest();        
    }//END testMigrationJob
    
    @isTest
    static void testValidationJob(){ 
        //List<DM_Loan_Account__c> dmList = [select id from DM_Loan_Account__c];
        //User u = [Select Id from User limit 1];
        //system.runAs(u){
            Test.startTest();
            DM_Loan_Account__c dmloanvalid = [Select Id, DM_Valid_Data__c from DM_Loan_Account__c limit 1];
            dmloanvalid.DM_Valid_Data__c = False;
            update dmloanvalid;
            INV_DM_ValidationJob dm = new INV_DM_ValidationJob();
            Database.executeBatch(dm);
            INV_DM_ValidationWrapper dmWrapper1 = new INV_DM_ValidationWrapper();
            DM_Loan_Account__c dmloanTest = [Select Id from DM_Loan_Account__c limit 1];
            INV_DM_ValidationWrapper dmWrapper2 = new INV_DM_ValidationWrapper(dmloanTest.Id, True, 'SampleTest');
            Test.stopTest();
          
    }//END testValidationJob   
    
   
    @isTest
    static void testValidation(){        
            Test.startTest();
            
            List<INV_DM_ValidationWrapper> validationWrapperList = new List<INV_DM_ValidationWrapper>();
            List<DM_Loan_Account__c> dmLoanList = new List<DM_Loan_Account__c>();
            
            Account b1 = [Select Id, Name from Account limit 1];
            loan__Fee_Set__c dummyFeeSet = [Select Id, name from loan__Fee_Set__c limit 1];
            loan__Loan_Product__c simpleLP = [Select Id, Name from loan__Loan_Product__c limit 1];
            loan__Office_Name__c dummyOffice = [Select Id, Name from loan__Office_Name__c limit 1];
            DM_Automated_Payment_Setup__c aps = [Select Id, Name from DM_Automated_Payment_Setup__c limit 1];
            //DM_Loan_Payment_Transaction__c lpt = [Select Id, Name from DM_Loan_Payment_Transaction__c limit 1];
            DM_Loan_Account__c dmloan = [select id, 
                                         DM_Interest_Calculation_Method__c, 
                                         DM_Time_Counting_Method__c ,
                                         DM_Product__c  ,
                                         DM_Product_Type__c  ,
                                         DM_Number_of_Installments__c  ,
                                         DM_Grace_Period_for_Repayments__c ,
                                         DM_Delinquency_Grace_Days__c ,
                                         DM_Pre_Bill_Days__c ,
                                         DM_Loan_Amount__c ,
                                         DM_Contractual_Interest_Rate__c ,
                                         DM_Account__c ,
                                         DM_Contact__c ,
                                         DM_Due_Day__c ,
                                         DM_Expected_Repayment_Start_Date__c
                                         from DM_Loan_Account__c limit 1];
            loan__Payment_Mode__c pMode = new loan__Payment_Mode__c(name='Cash');
            
            DM_Loan_Account__c dmloan1 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan1.DM_Time_Counting_Method__c = null;
            dmLoanList.add(dmloan1);
            
            DM_Loan_Account__c dmloan2 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan2.DM_Product__c  = null;
            dmLoanList.add(dmloan2);
            
            DM_Loan_Account__c dmloan3 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan3.DM_Interest_Calculation_Method__c = null;
            dmLoanList.add(dmloan3);
            
            DM_Loan_Account__c dmloan4 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan4.DM_Product_Type__c  = null;
            dmLoanList.add(dmloan4);
            
            DM_Loan_Account__c dmloan5 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan5.DM_Number_of_Installments__c = null;
            dmLoanList.add(dmloan5);
            
            DM_Loan_Account__c dmloan6 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan6.DM_Grace_Period_for_Repayments__c = null;
            dmLoanList.add(dmloan6);
            
            DM_Loan_Account__c dmloan7 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan7.DM_Delinquency_Grace_Days__c = null;
            dmLoanList.add(dmloan7);
            
            DM_Loan_Account__c dmloan8 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan8.DM_Pre_Bill_Days__c = null;
            dmLoanList.add(dmloan8);
            
            DM_Loan_Account__c dmloan9 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan9.DM_Loan_Amount__c  = null;
            dmLoanList.add(dmloan9);
            
            DM_Loan_Account__c dmloan10 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan10.DM_Contractual_Interest_Rate__c = 0;
            dmLoanList.add(dmloan10);
            
            DM_Loan_Account__c dmloan11 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan11.DM_Account__c = null;
            dmloan11.DM_Contact__c = null;
            dmLoanList.add(dmloan11);
            
            DM_Loan_Account__c dmloan12 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
            dmloan12.DM_Due_Day__c = null;
            dmLoanList.add(dmloan12);
                       
            
            DM_Loan_Payment_Transaction__c lpt1 = INV_DM_TestHelper.createLoanPayment(dmloan.Id, 10000.00,Date.today(),aPS, pMode, null);
            lpt1.DM_Transaction_Amount__c = null;
            dmLoanList.add(dmloan);
            
            INV_DM_Validation handler = new INV_DM_Validation();
            validationWrapperList = handler.validateDM(dmLoanList);
            handler.testcoverage();
            Test.stopTest();
          
    }//END testValidation         
    
}//END INV_DMTool_Test