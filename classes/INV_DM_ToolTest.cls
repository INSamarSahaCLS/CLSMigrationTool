/******************************************************************************************************************
* Author: Samar Saha
* Date: Oct - 2019
* Update History - 
********************************************************************************************************************/ 
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
        dmloan.DM_Valid_Data__c = False;
        dmloan.Migration_status__c = 'Pending';
        dmLoanList.add(dmloan);
        
        DM_Loan_Account__c dmloan2 = INV_DM_TestHelper.createDMLOC(difficultLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan2.DM_Valid_Data__c = True;
        dmloan2.Migration_status__c = 'Validated';
        dmloan2.DM_Is_Migrated__c = False;
        
        dmLoanList.add(dmloan2);
        
        DM_Loan_Account__c dmloan3 = INV_DM_TestHelper.createDMLOC(errorLp,0.0,b1,dummyFeeSet,dummyOffice,5,'Error');
        dmloan3.DM_Valid_Data__c = true;
        dmloan3.Migration_status__c = 'Validated';
        dmloan3.DM_Is_Migrated__c = false; 
        dmloan3.DM_Product_Type__c=null;       
        dmLoanList.add(dmloan3);
        
        DM_Loan_Account__c dmloan4 = INV_DM_TestHelper.createDMLOC(difficultLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan4.DM_Valid_Data__c = true;
        dmloan4.Migration_status__c = 'Validated';
        dmloan4.DM_Is_Migrated__c = false;
        dmloan4.DM_Loan_Amount__c=null;
        dmLoanList.add(dmloan4);
        
        DM_Loan_Account__c dmloan5 = INV_DM_TestHelper.createDMLOC(difficultLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan5.DM_Valid_Data__c = true;
        dmloan5.Migration_status__c = 'Validated';
        dmloan5.DM_Is_Migrated__c = false;      
        dmLoanList.add(dmloan5);
        
        DM_Loan_Account__c dmloan6 = INV_DM_TestHelper.createDMLOC(errorLp,0.0,b1,dummyFeeSet,dummyOffice,5,'Error');
        dmloan6.DM_Valid_Data__c = true;
        dmloan6.Migration_status__c = 'Validated';
        dmloan6.DM_Is_Migrated__c = false;      
        dmLoanList.add(dmloan6);   
        
        insert dmLoanList;        
        
        List<DM_Loan_Disbursal_Transaction__c> ldtList = new List<DM_Loan_Disbursal_Transaction__c>();
        DM_Loan_Disbursal_Transaction__c ldt1 =  INV_DM_TestHelper.fundLoan(dmLoan, Date.Today(), pmode,bankAccount);
        DM_Loan_Disbursal_Transaction__c ldt2 =  INV_DM_TestHelper.fundLoan(dmloan2, Date.Today(), pmode,bankAccount);
        DM_Loan_Disbursal_Transaction__c ldt3 =  INV_DM_TestHelper.fundLoan(dmloan5, Date.Today(), pMode,bankAccount);  
        ldt3.Dm_Disbursal_Date__c=null;             
        ldtList.add(ldt1);
        ldtList.add(ldt2);
        ldtList.add(ldt3);
        insert ldtList;
        
        List<DM_Bill__c> billList = new List<DM_Bill__c>();                                                
        DM_Bill__c bill1 =  INV_DM_TestHelper.createUnpaidDue(dmLoan, 6500.00);
        DM_Bill__c bill2 =  INV_DM_TestHelper.createUnpaidDue(dmLoan2, 6500.00);
        billList.add(bill1);
        billList.add(bill2);
        insert billList;
        
        List<DM_Repayment_Schedule_Summary__c> rssList = new List<DM_Repayment_Schedule_Summary__c>();   
        DM_Repayment_Schedule_Summary__c dm_RSS1 = INV_DM_TestHelper.CreateRSSData(dmLoan, 600.00);
        DM_Repayment_Schedule_Summary__c dm_RSS2 = INV_DM_TestHelper.CreateRSSData(dmLoan2, 600.00);
        rssList.add(dm_RSS1);
        rssList.add(dm_RSS2);
        insert rssList;
        
        List<DM_Charge__c> chargeList = new List<DM_Charge__c>();  
        DM_Charge__c charge1 =  INV_DM_TestHelper.createUnpaidCharge(dmLoan, dummyFee, 100.00);
        DM_Charge__c charge2 =  INV_DM_TestHelper.createUnpaidCharge(dmLoan2, dummyFee, 100.00);
        chargeList.add(charge1);
        chargeList.add(charge2);
        insert chargeList;
        
        List<DM_Repayment_Schedule__c> amortList = new List<DM_Repayment_Schedule__c>(); 
        DM_Repayment_Schedule__c AmzSchedule1 = INV_DM_TestHelper.CreateAmzScheduleData(dmLoan, 1000.00);
        DM_Repayment_Schedule__c AmzSchedule2 = INV_DM_TestHelper.CreateAmzScheduleData(dmLoan2, 1000.00);
        amortList.add(AmzSchedule1);
        amortList.add(AmzSchedule2);
        insert amortList;
        
        List<DM_Automated_Payment_Setup__c> apsList = new List<DM_Automated_Payment_Setup__c>();  
        DM_Automated_Payment_Setup__c aps1 =  INV_DM_TestHelper.createAutomatedPaymentSetup('DO it later', '', bankAccount,
                                                                                            dmLoan, '', pMode, Date.Today(),1);
        DM_Automated_Payment_Setup__c aps2 =  INV_DM_TestHelper.createAutomatedPaymentSetup('DO it later', '', bankAccount,
                                                                                            dmLoan2, '', pMode, Date.Today(),1);     
        DM_Automated_Payment_Setup__c aps3 =  INV_DM_TestHelper.createAutomatedPaymentSetup('DO it later', '', bankAccount,
                                                                                            dmloan6, '', pMode, Date.Today(),1);         
        aps3.DM_Debit_Day__c = null;
        aps3.DM_Type__c = null;   
        apsList.add(aps1);
        apsList.add(aps2);
        apsList.add(aps3);
        insert apsList;
        
        List<DM_Loan_Payment_Transaction__c> lptList = new List<DM_Loan_Payment_Transaction__c>();
        DM_Loan_Payment_Transaction__c lpt1 = INV_DM_TestHelper.createLoanPayment(dmLoan.Id, 10000.00,Date.today(),aps1, pMode, null);
        DM_Loan_Payment_Transaction__c lpt2 = INV_DM_TestHelper.createLoanPayment(dmLoan2.Id, 10000.00,Date.today(),aps2, pMode, null);
        DM_Loan_Payment_Transaction__c lpt3 = INV_DM_TestHelper.createLoanPayment(dmloan4.Id, 10000.00,Date.today(),aps3, pMode, null);
        lpt3.DM_Principal__c=null;
        lpt3.DM_Receipt_Date__c=null;      
        lptList.add(lpt1);
        lptList.add(lpt2);
        lptList.add(lpt3);
        insert lptList;
        
        List<DM_Interest_Posting_Transaction__c> iptList = new List<DM_Interest_Posting_Transaction__c>();
        DM_Interest_Posting_Transaction__c ipt1 = INV_DM_TestHelper.CreateIPTData(dmLoan);
        DM_Interest_Posting_Transaction__c ipt2 = INV_DM_TestHelper.CreateIPTData(dmLoan2);
        iptList.add(ipt1);
        iptList.add(ipt2);
        insert iptList;
        
        List<Migration_Tool_Configuration__c> mtc = new List<Migration_Tool_Configuration__c>();
        mtc = INV_DM_TestHelper.CreateMigrationToolConfigRecords();
        insert mtc;
        
        DM_Tool_Settings__c dmToolCS = DM_Tool_Settings__c.getOrgDefaults();
        dmToolCS.Enable_Strategy_0__c = true;
        dmToolCS.Migrate_Amort_Schedule__c = true;
        dmToolCS.Migrate_RSS_Schedule__c = true;
        insert dmToolCS;
        
    }//END testData
    
    
    @isTest
    static void testMigrationJob(){ 
        Test.startTest();                                                                        
        DM_Tool_Settings__c cs = DM_Tool_Settings__c.getOrgdefaults();                                                             
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
    static void testJobController(){
        Test.startTest();
        INV_DM_JobsController con=new INV_DM_JobsController();
        con.runValidationJob();
        con.runMigrationJob();
        Test.stopTest();
    }//End JobController
    
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
        
        loan__Payment_Mode__c pymentmode = new loan__Payment_Mode__c(name='Cash');
        insert pymentmode;
        
        //Dm Loan Account test data
        DM_Loan_Account__c dmloan1 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan1.DM_Product_Type__c = 'Simple Loan';
        dmloan1.DM_Loan_Amount__c =400;
        dmloan1.migration_Status__C='Pending'; 
        dmloan1.DM_Valid_Data__c=false;  
        dmloan1.DM_Account__c= b1.Id; 
        dmloan1.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan1.DM_Interest_Rate__c=4;
        dmloan1.DM_Contractual_Interest_Rate__c=4;
        dmloan1.DM_Overdue_Interest_Rate__c=4;
        dmloan1.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan1.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan1.DM_Product__c = simpleLP.ID;
        dmloan1.DM_Number_of_Installments__c=60;
        dmloan1.DM_Term_Cur__c=60; 
        dmloan1.DM_Due_Day__c=5;
        dmloan1.DM_Grace_Period_for_Repayments__c = 10;
        dmloan1.DM_Delinquency_Grace_Days__c = 10;
        dmloan1.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan1);            
        
        DM_Loan_Account__c dmloan2 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan2.DM_Product_Type__c = 'Simple Loan';
        dmloan2.DM_Loan_Amount__c =400;
        dmloan2.migration_Status__C='Pending'; 
        dmloan2.DM_Valid_Data__c=false;  
        dmloan2.DM_Account__c= b1.Id; 
        dmloan2.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan2.DM_Interest_Rate__c=4;
        dmloan2.DM_Contractual_Interest_Rate__c=4;
        dmloan2.DM_Overdue_Interest_Rate__c=4;
        dmloan2.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan2.DM_Interest_Calculation_Method__c=null;
        dmloan2.DM_Product__c = simpleLP.ID;
        dmloan2.DM_Number_of_Installments__c=60;
        dmloan2.DM_Term_Cur__c=60; 
        dmloan2.DM_Due_Day__c=5;
        dmloan2.DM_Grace_Period_for_Repayments__c = 10;
        dmloan2.DM_Delinquency_Grace_Days__c = 10;
        dmloan2.DM_Pre_Bill_Days__c = 10;            
        dmLoanList.add(dmloan2);
        
        DM_Loan_Account__c dmloan3 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan3.DM_Product_Type__c = 'Simple Loan';
        dmloan3.DM_Loan_Amount__c =400;
        dmloan3.migration_Status__C='Pending'; 
        dmloan3.DM_Valid_Data__c=false;  
        dmloan3.DM_Account__c= b1.Id; 
        dmloan3.DM_Time_Counting_Method__c =null;
        dmloan3.DM_Interest_Rate__c=4;
        dmloan3.DM_Contractual_Interest_Rate__c=4;
        dmloan3.DM_Overdue_Interest_Rate__c=4;
        dmloan3.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan3.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan3.DM_Product__c = simpleLP.ID;
        dmloan3.DM_Number_of_Installments__c=60;
        dmloan3.DM_Term_Cur__c=60; 
        dmloan3.DM_Due_Day__c=5;
        dmloan3.DM_Grace_Period_for_Repayments__c = 10;
        dmloan3.DM_Delinquency_Grace_Days__c = 10;
        dmloan3.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan3);
        
        DM_Loan_Account__c dmloan4 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan4.DM_Product_Type__c = 'Simple Loan';
        dmloan4.DM_Loan_Amount__c =400;
        dmloan4.migration_Status__C='Pending'; 
        dmloan4.DM_Valid_Data__c=false;  
        dmloan4.DM_Account__c= b1.Id; 
        dmloan4.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan4.DM_Interest_Rate__c=4;
        dmloan4.DM_Contractual_Interest_Rate__c=4;
        dmloan4.DM_Overdue_Interest_Rate__c=4;
        dmloan4.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan4.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan4.DM_Product__c =null;
        dmloan4.DM_Number_of_Installments__c=60;
        dmloan4.DM_Term_Cur__c=60; 
        dmloan4.DM_Due_Day__c=5;
        dmloan4.DM_Grace_Period_for_Repayments__c = 10;
        dmloan4.DM_Delinquency_Grace_Days__c = 10;
        dmloan4.DM_Pre_Bill_Days__c = 10;  
        dmLoanList.add(dmloan4);
        
        DM_Loan_Account__c dmloan5 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan5.DM_Product_Type__c = null;
        dmloan5.DM_Loan_Amount__c =400;
        dmloan5.migration_Status__C='Pending'; 
        dmloan5.DM_Valid_Data__c=false;  
        dmloan5.DM_Account__c= b1.Id; 
        dmloan5.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan5.DM_Interest_Rate__c=4;
        dmloan5.DM_Contractual_Interest_Rate__c=4;
        dmloan5.DM_Overdue_Interest_Rate__c=4;
        dmloan5.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan5.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan5.DM_Product__c = simpleLP.ID;
        dmloan5.DM_Number_of_Installments__c=60;
        dmloan5.DM_Term_Cur__c=60; 
        dmloan5.DM_Due_Day__c=5;
        dmloan5.DM_Grace_Period_for_Repayments__c = 10;
        dmloan5.DM_Delinquency_Grace_Days__c = 10;
        dmloan5.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan5);
        
        DM_Loan_Account__c dmloan6 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan6.DM_Product_Type__c = 'Simple Loan';
        dmloan6.DM_Loan_Amount__c =400;
        dmloan6.migration_Status__C='Pending'; 
        dmloan6.DM_Valid_Data__c=false;  
        dmloan6.DM_Account__c= b1.Id; 
        dmloan6.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan6.DM_Interest_Rate__c=4;
        dmloan6.DM_Contractual_Interest_Rate__c=4;
        dmloan6.DM_Overdue_Interest_Rate__c=4;
        dmloan6.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan6.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan6.DM_Product__c = simpleLP.ID;
        dmloan6.DM_Number_of_Installments__c=null;
        dmloan6.DM_Term_Cur__c=60; 
        dmloan6.DM_Due_Day__c=5;
        dmloan6.DM_Grace_Period_for_Repayments__c = 10;
        dmloan6.DM_Delinquency_Grace_Days__c = 10;
        dmloan6.DM_Pre_Bill_Days__c = 10;     
        dmLoanList.add(dmloan6);
        
        DM_Loan_Account__c dmloan7 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan7.DM_Product_Type__c = 'Simple Loan';
        dmloan7.DM_Loan_Amount__c =400;
        dmloan7.migration_Status__C='Pending'; 
        dmloan7.DM_Valid_Data__c=false;  
        dmloan7.DM_Account__c= b1.Id; 
        dmloan7.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan7.DM_Interest_Rate__c=4;
        dmloan7.DM_Contractual_Interest_Rate__c=4;
        dmloan7.DM_Overdue_Interest_Rate__c=4;
        dmloan7.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan7.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan7.DM_Product__c = simpleLP.ID;
        dmloan7.DM_Number_of_Installments__c=60;
        dmloan1.DM_Term_Cur__c=60; 
        dmloan7.DM_Due_Day__c=5;
        dmloan7.DM_Grace_Period_for_Repayments__c =null;
        dmloan7.DM_Delinquency_Grace_Days__c = 10;
        dmloan7.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan7);
        
        DM_Loan_Account__c dmloan8 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan8.DM_Product_Type__c = 'Simple Loan';
        dmloan8.DM_Loan_Amount__c =400;
        dmloan8.migration_Status__C='Pending'; 
        dmloan8.DM_Valid_Data__c=false;  
        dmloan8.DM_Account__c= b1.Id; 
        dmloan8.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan8.DM_Interest_Rate__c=4;
        dmloan8.DM_Contractual_Interest_Rate__c=4;
        dmloan8.DM_Overdue_Interest_Rate__c=4;
        dmloan8.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan8.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan8.DM_Product__c = simpleLP.ID;
        dmloan8.DM_Number_of_Installments__c=60;
        dmloan8.DM_Term_Cur__c=60; 
        dmloan8.DM_Due_Day__c=5;
        dmloan8.DM_Grace_Period_for_Repayments__c = 10;
        dmloan8.DM_Delinquency_Grace_Days__c =null;
        dmloan8.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan8);
        
        DM_Loan_Account__c dmloan9 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan9.DM_Product_Type__c = 'Simple Loan';
        dmloan9.DM_Loan_Amount__c =400;
        dmloan9.migration_Status__C='Pending'; 
        dmloan9.DM_Valid_Data__c=false;  
        dmloan9.DM_Account__c= b1.Id; 
        dmloan9.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan9.DM_Interest_Rate__c=4;
        dmloan9.DM_Contractual_Interest_Rate__c=4;
        dmloan9.DM_Overdue_Interest_Rate__c=4;
        dmloan9.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan9.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan9.DM_Product__c = simpleLP.ID;
        dmloan9.DM_Number_of_Installments__c=60;
        dmloan9.DM_Term_Cur__c=60; 
        dmloan9.DM_Due_Day__c=5;
        dmloan9.DM_Grace_Period_for_Repayments__c = 10;
        dmloan9.DM_Delinquency_Grace_Days__c = 10;
        dmloan9.DM_Pre_Bill_Days__c =null;        
        dmLoanList.add(dmloan9);
        
        
        DM_Loan_Account__c dmloan10 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');           
        dmloan10.DM_Product_Type__c = 'Simple Loan';
        dmloan10.DM_Loan_Amount__c =null;
        dmloan10.migration_Status__C='Pending'; 
        dmloan10.DM_Valid_Data__c=false;  
        dmloan10.DM_Account__c= b1.Id; 
        dmloan10.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan10.DM_Interest_Rate__c=4;
        dmloan10.DM_Contractual_Interest_Rate__c=4;
        dmloan10.DM_Overdue_Interest_Rate__c=4;
        dmloan10.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan10.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan10.DM_Product__c = simpleLP.ID;
        dmloan10.DM_Number_of_Installments__c=60;
        dmloan10.DM_Term_Cur__c=60; 
        dmloan10.DM_Due_Day__c=5;
        dmloan10.DM_Grace_Period_for_Repayments__c = 10;
        dmloan10.DM_Delinquency_Grace_Days__c = 10;
        dmloan10.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan10);
        
        DM_Loan_Account__c dmloan11 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan11.DM_Product_Type__c = 'Simple Loan';
        dmloan11.DM_Loan_Amount__c =400;
        dmloan11.migration_Status__C='Pending'; 
        dmloan11.DM_Valid_Data__c=false;  
        dmloan11.DM_Account__c= b1.Id; 
        dmloan11.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan11.DM_Interest_Rate__c=4;
        dmloan11.DM_Contractual_Interest_Rate__c=null;
        dmloan11.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan11.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan11.DM_Product__c = simpleLP.ID;
        dmloan11.DM_Number_of_Installments__c=60;
        dmloan11.DM_Term_Cur__c=60; 
        dmloan11.DM_Due_Day__c=5;
        dmloan11.DM_Grace_Period_for_Repayments__c = 10;
        dmloan11.DM_Delinquency_Grace_Days__c = 10;
        dmloan11.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan11);
        
        DM_Loan_Account__c dmloan12 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan1.DM_Product_Type__c = 'Simple Loan';
        dmloan12.DM_Loan_Amount__c =400;
        dmloan12.migration_Status__C='Pending'; 
        dmloan12.DM_Valid_Data__c=false;  
        dmloan12.DM_Account__c=null; 
        dmloan12.DM_Contact__c=null;
        dmloan12.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan12.DM_Interest_Rate__c=4;
        dmloan12.DM_Contractual_Interest_Rate__c=4;
        dmloan12.DM_Overdue_Interest_Rate__c=4;
        dmloan12.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan12.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan12.DM_Product__c = simpleLP.ID;
        dmloan12.DM_Number_of_Installments__c=60;
        dmloan12.DM_Term_Cur__c=60; 
        dmloan12.DM_Due_Day__c=5;
        dmloan12.DM_Grace_Period_for_Repayments__c = 10;
        dmloan12.DM_Delinquency_Grace_Days__c = 10;
        dmloan12.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan12);
        
        DM_Loan_Account__c dmloan13 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan13.DM_Product_Type__c = 'Simple Loan';
        dmloan13.DM_Loan_Amount__c =400;
        dmloan13.migration_Status__C='Pending'; 
        dmloan13.DM_Valid_Data__c=false;  
        dmloan13.DM_Account__c= b1.Id; 
        dmloan13.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan13.DM_Interest_Rate__c=4;
        dmloan13.DM_Contractual_Interest_Rate__c=4;
        dmloan13.DM_Overdue_Interest_Rate__c=4;
        dmloan13.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan13.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan13.DM_Product__c = simpleLP.ID;
        dmloan13.DM_Number_of_Installments__c=60;
        dmloan13.DM_Term_Cur__c=60; 
        dmloan13.DM_Due_Day__c=0;
        dmloan13.DM_Grace_Period_for_Repayments__c = 10;
        dmloan13.DM_Delinquency_Grace_Days__c = 10;
        dmloan13.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan13);
        
        DM_Loan_Account__c dmloan14 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan14.DM_Product_Type__c = 'Simple Loan';
        dmloan14.DM_Loan_Amount__c =400;
        dmloan14.migration_Status__C='Pending'; 
        dmloan14.DM_Valid_Data__c=false; 
        dmloan14.DM_Expected_Disbursal_Date__c=system.today()+2;
        dmloan14.DM_Expected_Repayment_Start_Date__c=system.today()-5;  
        dmloan14.DM_Account__c= b1.Id; 
        dmloan14.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan14.DM_Interest_Rate__c=4;
        dmloan14.DM_Contractual_Interest_Rate__c=4;
        dmloan14.DM_Overdue_Interest_Rate__c=4;
        dmloan14.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan14.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan14.DM_Product__c = simpleLP.ID;
        dmloan14.DM_Number_of_Installments__c=60;
        dmloan14.DM_Term_Cur__c=60; 
        dmloan14.DM_Due_Day__c=5;
        dmloan14.DM_Grace_Period_for_Repayments__c = 10;
        dmloan14.DM_Delinquency_Grace_Days__c = 10;
        dmloan14.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan14);
        
        DM_Loan_Account__c dmloan15 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan15.DM_Product_Type__c = 'Simple Loan';
        dmloan15.DM_Loan_Amount__c =400;
        dmloan15.migration_Status__C='Pending'; 
        dmloan15.DM_Valid_Data__c=false;  
        dmloan15.DM_Account__c= b1.Id; 
        dmloan15.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan15.DM_Interest_Rate__c=4;
        dmloan15.DM_Contractual_Interest_Rate__c=4;
        dmloan15.DM_Overdue_Interest_Rate__c=4;
        dmloan15.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan15.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan15.DM_Product__c = simpleLP.ID;
        dmloan15.DM_Number_of_Installments__c=60;
        dmloan15.DM_Term_Cur__c=60; 
        dmloan15.DM_Due_Day__c=5;
        dmloan15.DM_Grace_Period_for_Repayments__c = 10;
        dmloan15.DM_Delinquency_Grace_Days__c = 10;
        dmloan15.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan15);            
        
        DM_Loan_Account__c dmloan16 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan16.DM_Product_Type__c = 'Simple Loan';
        dmloan16.DM_Loan_Amount__c =400;
        dmloan16.migration_Status__C='Pending'; 
        dmloan16.DM_Valid_Data__c=false;  
        dmloan16.DM_Account__c= b1.Id; 
        dmloan16.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan16.DM_Interest_Rate__c=4;
        dmloan16.DM_Contractual_Interest_Rate__c=4;
        dmloan16.DM_Overdue_Interest_Rate__c=4;
        dmloan16.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan16.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan16.DM_Product__c = simpleLP.ID;
        dmloan16.DM_Number_of_Installments__c=60;
        dmloan16.DM_Term_Cur__c=60; 
        dmloan16.DM_Due_Day__c=5;
        dmloan16.DM_Grace_Period_for_Repayments__c = 10;
        dmloan16.DM_Delinquency_Grace_Days__c = 10;
        dmloan16.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan16);            
        
        DM_Loan_Account__c dmloan17 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan17.DM_Product_Type__c = 'Simple Loan';
        dmloan17.DM_Loan_Amount__c =400;
        dmloan17.migration_Status__C='Pending'; 
        dmloan17.DM_Valid_Data__c=false;  
        dmloan17.DM_Account__c= b1.Id; 
        dmloan17.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan17.DM_Interest_Rate__c=4;
        dmloan17.DM_Contractual_Interest_Rate__c=4;
        dmloan17.DM_Overdue_Interest_Rate__c=4;
        dmloan17.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan17.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan17.DM_Product__c = simpleLP.ID;
        dmloan17.DM_Number_of_Installments__c=60;
        dmloan17.DM_Term_Cur__c=60; 
        dmloan17.DM_Due_Day__c=5;
        dmloan17.DM_Grace_Period_for_Repayments__c = 10;
        dmloan17.DM_Delinquency_Grace_Days__c = 10;
        dmloan17.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan17);            
        
        DM_Loan_Account__c dmloan18 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan18.DM_Product_Type__c = 'Simple Loan';
        dmloan18.DM_Loan_Amount__c =400;
        dmloan18.migration_Status__C='Pending'; 
        dmloan18.DM_Valid_Data__c=false;  
        dmloan18.DM_Account__c= b1.Id; 
        dmloan18.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan18.DM_Interest_Rate__c=4;
        dmloan18.DM_Contractual_Interest_Rate__c=4;
        dmloan18.DM_Overdue_Interest_Rate__c=4;
        dmloan18.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan18.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan18.DM_Product__c = simpleLP.ID;
        dmloan18.DM_Number_of_Installments__c=60;
        dmloan18.DM_Term_Cur__c=60; 
        dmloan18.DM_Due_Day__c=5;
        dmloan18.DM_Grace_Period_for_Repayments__c = 10;
        dmloan18.DM_Delinquency_Grace_Days__c = 10;
        dmloan18.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan18);            
        
        DM_Loan_Account__c dmloan19 = INV_DM_TestHelper.createDMLOC(simpleLP,0.0,b1,dummyFeeSet,dummyOffice,5,'Declining Balance');
        dmloan19.DM_Product_Type__c = 'Simple Loan';
        dmloan19.DM_Loan_Amount__c =400;
        dmloan19.migration_Status__C='Pending'; 
        dmloan19.DM_Valid_Data__c=false;  
        dmloan19.DM_Account__c= b1.Id; 
        dmloan19.DM_Time_Counting_Method__c = 'Actual Days';
        dmloan19.DM_Interest_Rate__c=4;
        dmloan19.DM_Contractual_Interest_Rate__c=4;
        dmloan19.DM_Overdue_Interest_Rate__c=4;
        dmloan19.DM_Interest_Only_Payment_Amt__c=100; 
        dmloan19.DM_Interest_Calculation_Method__c='Declining Balance';
        dmloan19.DM_Product__c = simpleLP.ID;
        dmloan19.DM_Number_of_Installments__c=60;
        dmloan19.DM_Term_Cur__c=60; 
        dmloan19.DM_Due_Day__c=5;
        dmloan19.DM_Grace_Period_for_Repayments__c = 10;
        dmloan19.DM_Delinquency_Grace_Days__c = 10;
        dmloan19.DM_Pre_Bill_Days__c = 10;        
        dmLoanList.add(dmloan19);            
        insert dmLoanList;            
        
        
        //LPT test data
        Date myDate = Date.newInstance(2019, 11, 18);
        Time myTime = Time.newInstance(3, 3, 3, 0);
        DateTime dt = DateTime.newInstance(myDate, myTime);
        
        List<DM_Loan_Payment_Transaction__c> lptList =new List<DM_Loan_Payment_Transaction__c>();
        DM_Loan_Payment_Transaction__c lpt1 = INV_DM_TestHelper.createLoanPayment(dmloan1.Id, 10000.00,Date.today(),aPS, pymentmode, null);
        lpt1.DM_Transaction_Date__c = system.today();
        lpt1.CL_Contract__c=dmloan1.Id;
        lpt1.DM_Transaction_Amount__c = 1000;           
        lpt1.DM_Receipt_Date__c= Date.today();                                                                
        lpt1.DM_Interest__c = 4;      
        lpt1.DM_Automated_Payment_Setup__c =aps.Id;
        lpt1.DM_Payment_Mode__c =pymentmode.id;
        lpt1.DM_Cleared__c =true;
        lpt1.DM_Principal__c=800;
        lpt1.DM_Fees__c=50;
        lpt1.DM_Transaction_Time__c=dt;
        lptList.add(lpt1);
        
        DM_Loan_Payment_Transaction__c lpt2 = INV_DM_TestHelper.createLoanPayment(dmloan1.Id, 10000.00,Date.today(),aPS, pymentmode, null);
        lpt2.DM_Transaction_Date__c = system.today();
        lpt2.CL_Contract__c=dmloan1.Id;
        lpt2.DM_Transaction_Amount__c = 1000;           
        lpt2.DM_Receipt_Date__c= Date.today();                                                                
        lpt2.DM_Interest__c =4;      
        lpt2.DM_Automated_Payment_Setup__c =aps.Id;
        lpt2.DM_Payment_Mode__c =null; 
        lpt2.DM_Cleared__c =true;
        lpt2.DM_Principal__c=800;
        lpt2.DM_Fees__c=50;
        lpt2.DM_Transaction_Time__c=dt;
        lptList.add(lpt2);
        
        DM_Loan_Payment_Transaction__c lpt3 = INV_DM_TestHelper.createLoanPayment(dmloan15.Id, 10000.00,Date.today(),aPS, pymentmode, null);
        lpt3.DM_Transaction_Date__c = system.today();
        lpt3.CL_Contract__c=dmloan15.Id;
        lpt3.DM_Transaction_Amount__c =1000;           
        lpt3.DM_Receipt_Date__c= null;                                                                
        lpt3.DM_Interest__c =4;      
        lpt3.DM_Automated_Payment_Setup__c =aps.Id;
        lpt3.DM_Payment_Mode__c =pymentmode.id;
        lpt3.DM_Cleared__c =true;
        lpt3.DM_Principal__c=800;
        lpt3.DM_Fees__c=50;
        lpt3.DM_Transaction_Time__c=dt;
        lptList.add(lpt3);
        
        DM_Loan_Payment_Transaction__c lpt4 = INV_DM_TestHelper.createLoanPayment(dmloan16.Id, 10000.00,Date.today(),aPS, pymentmode, null);
        lpt4.DM_Transaction_Date__c = system.today();
        lpt4.CL_Contract__c=dmloan16.Id;
        lpt4.DM_Transaction_Amount__c = 1000;           
        lpt4.DM_Receipt_Date__c= Date.today();                                                                
        lpt4.DM_Interest__c =4;      
        lpt4.DM_Automated_Payment_Setup__c =aps.Id;
        lpt4.DM_Payment_Mode__c =pymentmode.id;
        lpt4.DM_Cleared__c =true;
        lpt4.DM_Principal__c=null;
        lpt4.DM_Fees__c=50;
        lpt4.DM_Transaction_Time__c=dt;
        lptList.add(lpt4);
        
        DM_Loan_Payment_Transaction__c lpt5 = INV_DM_TestHelper.createLoanPayment(dmloan17.Id, 10000.00,Date.today(),aPS, pymentmode, null);
        lpt5.DM_Transaction_Date__c = system.today();
        lpt5.CL_Contract__c=dmloan17.Id;
        lpt5.DM_Transaction_Amount__c = 1000;           
        lpt5.DM_Receipt_Date__c= Date.today();                                                                
        lpt5.DM_Interest__c =null;      
        lpt5.DM_Automated_Payment_Setup__c =aps.Id;
        lpt5.DM_Payment_Mode__c =pymentmode.id;
        lpt5.DM_Cleared__c =true;
        lpt5.DM_Principal__c=800;
        lpt5.DM_Fees__c=50;
        lpt5.DM_Transaction_Time__c=dt;
        lptList.add(lpt5);
        
        DM_Loan_Payment_Transaction__c lpt6 = INV_DM_TestHelper.createLoanPayment(dmloan18.Id, 10000.00,Date.today(),aPS, pymentmode, null);
        lpt6.DM_Transaction_Date__c = system.today();
        lpt6.CL_Contract__c=dmloan18.Id;
        lpt6.DM_Transaction_Amount__c = 1000;           
        lpt6.DM_Receipt_Date__c= Date.today();                                                                
        lpt6.DM_Interest__c = 4;      
        lpt6.DM_Automated_Payment_Setup__c =aps.Id;
        lpt6.DM_Payment_Mode__c =pymentmode.id;
        lpt6.DM_Cleared__c =true;
        lpt6.DM_Principal__c=800;
        lpt6.DM_Fees__c=null;
        lpt6.DM_Transaction_Time__c=dt;
        lptList.add(lpt6);
        
        DM_Loan_Payment_Transaction__c lpt7 = INV_DM_TestHelper.createLoanPayment(dmloan19.Id, 10000.00,Date.today(),aPS, pymentmode, null);
        lpt7.DM_Transaction_Date__c = system.today();
        lpt7.CL_Contract__c=dmloan19.Id;
        lpt7.DM_Transaction_Amount__c = 1000;           
        lpt7.DM_Receipt_Date__c= Date.today();                                                                
        lpt7.DM_Interest__c = 4;      
        lpt7.DM_Automated_Payment_Setup__c =aps.Id;
        lpt7.DM_Payment_Mode__c =pymentmode.id;
        lpt7.DM_Cleared__c =true;
        lpt7.DM_Principal__c=800;
        lpt7.DM_Fees__c=50;
        lpt7.DM_Transaction_Time__c=null;
        lptList.add(lpt7);                
        insert lptList;                   
        
        List<DM_Loan_Account__c> dmloanList2 = [select id,DM_Interest_Calculation_Method__c,DM_Time_Counting_Method__c ,DM_Product__c  ,DM_Product_Type__c  ,
                                                DM_Number_of_Installments__c,DM_Grace_Period_for_Repayments__c,DM_Delinquency_Grace_Days__c ,DM_Pre_Bill_Days__c ,DM_Loan_Amount__c ,
                                                DM_Contractual_Interest_Rate__c ,DM_Account__c ,DM_Contact__c ,DM_Due_Day__c ,DM_Expected_Repayment_Start_Date__c,DM_Expected_Disbursal_Date__c,
                                                Batch_Type__c,(Select id,DM_Transaction_Date__c,DM_Transaction_Amount__c,DM_Receipt_Date__c,DM_Interest__c,DM_Automated_Payment_Setup__c,
                                                                       DM_Payment_Mode__c,DM_Cleared__c,DM_Principal__c,DM_Fees__c,DM_Transaction_Time__c,DM_Clearing_Date__c from DM_Loan_Payment_Transactions__r) from DM_Loan_Account__c];              
        
        
        INV_DM_ValidationWrapper dmWrapper2 = new INV_DM_ValidationWrapper(dmLoanList2[0].Id, True, 'SampleTest');
        //DummyValidation handler = new DummyValidation();
        INV_DM_Validation handler = new INV_DM_Validation();
        validationWrapperList =handler.validateDM(dmLoanList2);          
        Test.stopTest();          
    }//END testValidation         
    
}//END INV_DMTool_Test