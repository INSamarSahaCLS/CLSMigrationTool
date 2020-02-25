/******************************************************************************************************************
* Author: Samar Saha 
* Date: Oct - 2019
* Update History - 
*****************************************************************************************************************/ 
public class INV_DM_Data_Creation {
    public List<DM_Loan_Account__c> errorUpdate = new List<DM_Loan_Account__c>();
    Savepoint sp;
    public void DataCreation(List<DM_Loan_Account__c> dmList){
        system.debug('Inside DataCreation Method');        
        
        DM_Tool_Settings__c dmToolCS = DM_Tool_Settings__c.getOrgDefaults();
        
        for(DM_Loan_Account__c dmloan : dmList){
            Id parentId;
            errorUpdate.clear();
            System.debug('DM Contract Id --> '+ dmloan.Id);
            parentid = insertLoanContract(dmloan);
            
            system.debug('ParentId --> '+parentId);         
            
            if(parentId<>null){  
                //insert Amort sch         
                if(errorUpdate.isEmpty() || Test.isRunningTest()){         
                    System.debug('errorUpdate-->' +errorUpdate);        
                    if(!dmloan.DM_Repayment_Schedules__r.isEmpty() && dmToolCS.Migrate_Amort_Schedule__c == True){
                        insertRepaySchedule(dmloan.DM_Repayment_Schedules__r, parentId, dmloan.Id);
                    }
                }
                //insert Sch summary
                if(errorUpdate.isEmpty() || Test.isRunningTest()){                 
                    if(!dmloan.DM_Repayment_Schedule_Summarys__r.isEmpty() && dmToolCS.Migrate_RSS_Schedule__c == True){
                        insertRepaymentSS(dmloan.DM_Repayment_Schedule_Summarys__r, parentId, dmloan.Id);
                    }
                }
                //insert LPT
                if(errorUpdate.isEmpty() || Test.isRunningTest()){                 
                    if(!dmloan.DM_Loan_Payment_Transactions__r.isEmpty() && dmToolCS.Enable_Strategy_0__c == True){
                        insertLPT(dmloan.DM_Loan_Payment_Transactions__r, parentId, dmloan.Id);
                    }
                }
                //insert LDT
                if(errorUpdate.isEmpty() || Test.isRunningTest()){                 
                    if(!dmloan.dm_Loan_Disbursal_Transactions__r.isEmpty() && dmToolCS.Enable_Strategy_0__c == True){
                        insertLDT(dmloan.dm_Loan_Disbursal_Transactions__r, parentId, dmloan.Id);
                    }
                }
                //insert APS
                if(errorUpdate.isEmpty() || Test.isRunningTest()){                 
                    if(!dmloan.DM_Automated_Payment_Setups__r.isEmpty() && dmToolCS.Enable_Strategy_0__c == True){
                        insertAPS(dmloan.DM_Automated_Payment_Setups__r, parentId, dmloan.Id);
                    }
                }
                //insert charges                                
                if(errorUpdate.isEmpty() || Test.isRunningTest()){                 
                    if(!dmloan.DM_Charges__r.isEmpty() && dmToolCS.Enable_Strategy_0__c == True){
                        insertCharges(dmloan.DM_Charges__r, parentId, dmloan.Id);
                    }
                }
                
                //insert IPT
                if(errorUpdate.isEmpty() || Test.isRunningTest()){                 
                    if(!dmloan.DM_Interest_Posting_Transactions__r.isEmpty() && dmToolCS.Enable_Strategy_0__c == True){
                        insertIPT(dmloan.DM_Interest_Posting_Transactions__r, parentId, dmloan.Id);
                    }
                }
            }            
            
            if(!errorUpdate.isEmpty()){
                if(!Test.isRunningTest()){
                    update errorUpdate;
                }
            }else{
                Dm_Loan_Account__c dmLoanSuccess = new Dm_loan_Account__c(Id = dmloan.Id, 
                                                                          migration_status__c = 'Migrated', 
                                                                          DM_Error__c = '', 
                                                                          DM_Invalid_Data__c = false,
                                                                          DM_valid_Data__c = True,                                                                 
                                                                          DM_Is_Migrated__c = True, 
                                                                          Migrated_CL_Contract__C = parentId);
                update dmLoanSuccess;
            }
        }
        
    }//Data Creation
    
    private Id insertLoanContract(DM_Loan_Account__c dmloan){
        system.debug('insertLoanContract');
        INV_DM_MigrationHandler dmHandler = new INV_DM_MigrationHandler();
        loan__Loan_Account__c loan;
        if(dmloan != null){
            try{
                loan = dmHandler.Dm_FieldMapping_LoanAccount(dmloan);
                system.debug('loan after mapping'+loan);
                if(loan<>null){
                    sp = Database.setSavepoint();
                }
                //loanList.add(loan);
                insert loan;
                return loan.Id;
            }
            catch(Exception ex){
                errorUpdate.add(new DM_Loan_Account__c(Id = dmloan.Id, 
                                                       DM_Error__c = 'Exception Thrown - CL Contract - '+ ex.getMessage(), 
                                                       DM_Invalid_Data__c = True, 
                                                       DM_valid_Data__c = False, 
                                                       migration_status__c='Failed'));
                return null;
            }       
        }      
        return null;
    }//END insertLoanContract        
    
    private void insertRepaySchedule(List<DM_Repayment_Schedule__c> dm_RepaySch, Id parentId, Id dmloanID){
        system.debug('inside insertRepaySchedule');
        loan__Repayment_Schedule__c repaySch;
        INV_DM_MigrationHandler dmHandler = new INV_DM_MigrationHandler();
        List<loan__Repayment_Schedule__c> repaySchList = new List<loan__Repayment_Schedule__c>();
        if(!dm_RepaySch.isEmpty()){
            for(DM_Repayment_Schedule__c dmRepaySch : dm_RepaySch){
                repaySch = dmHandler.DM_StaticFieldMapping_RepaySCH(dmRepaySch,parentId);
                system.debug('rePaySch'+repaySch);
                if(repaySch<>null)
                    repaySchList.add(repaySch);
            }    
            try{
                if(!repaySchList.isEmpty()){
                    //Create SavePoint
                    insert repaySchList;
                }     
            }catch(Exception ex){
                errorUpdate.add(new DM_Loan_Account__c(Id = dmloanID, 
                                                       DM_Error__c = 'Exception Thrown - Repayment Schedule - '+ ex.getMessage(), 
                                                       DM_valid_Data__c = False, 
                                                       DM_Invalid_Data__c = True));
                Database.rollback(sp);
            }  
        }
    }        
    
    private void insertRepaymentSS(List<DM_Repayment_Schedule_Summary__c> dm_Rss, Id parentId, Id dmloanID){
        system.debug('inside insertRepaymentSS');
        loan__Repayment_Schedule_Summary__c rss;
        INV_DM_MigrationHandler dmHandler = new INV_DM_MigrationHandler();
        List<loan__Repayment_Schedule_Summary__c> rssList = new List<loan__Repayment_Schedule_Summary__c>();
        if(!dm_Rss.isEmpty()){
            for(DM_Repayment_Schedule_Summary__c dmrss : dm_Rss){
                system.debug('dm rss'+rss);
                rss = dmHandler.DM_StaticFieldMapping_rss(dmrss,parentId);
                system.debug('rss'+rss);
                if(rss<>null)
                    rssList.add(rss);
            }    
            try{
                if(!rssList.isEmpty()){
                    //Create SavePoint
                    insert rssList;
                }     
            }catch(Exception ex){
                errorUpdate.add(new DM_Loan_Account__c(Id = dmloanID, 
                                                       DM_Error__c = 'Exception Thrown - RSS - '+ ex.getMessage(), 
                                                       DM_valid_Data__c = False, 
                                                       DM_Invalid_Data__c = True, 
                                                       migration_status__c = 'Failed'));
                Database.rollback(sp);
            }//END Catch   
        }
    }//insertRepaymentSS
    
    private void insertLPT(List<dm_Loan_Payment_Transaction__c> dm_lpt, Id parentId, Id dmloanID){
        system.debug('inside insertLPT');
        loan__Loan_Payment_Transaction__c lpt;
        INV_DM_MigrationHandler dmHandler = new INV_DM_MigrationHandler();
        List<loan__Loan_Payment_Transaction__c> lptList = new List<loan__Loan_Payment_Transaction__c>();
        if(!dm_lpt.isEmpty()){
            for(dm_Loan_Payment_Transaction__c dmlpt : dm_lpt){
                lpt = dmHandler.DM_StaticFieldMapping_lpt(dmlpt,parentId);
                if(lpt<>null)
                    lptList.add(lpt);
            }    
            try{
                if(!lptList.isEmpty()){
                    //Create SavePoint
                    insert lptList;
                }     
            }catch(Exception ex){
                errorUpdate.add(new DM_Loan_Account__c(Id = dmloanID, 
                                                       DM_Error__c = 'Exception Thrown - LPT - '+ ex.getMessage(), 
                                                       DM_valid_Data__c = False, 
                                                       DM_Invalid_Data__c = True, 
                                                       migration_status__c = 'Failed'));                          
                Database.rollback(sp);
            }//END Catch   
        }
    }//END insertLPT
    
    private void insertLDT(List<dm_Loan_Disbursal_Transaction__c> dm_ldt, Id parentId, Id dmloanID){
        system.debug('inside insertLDT');
        loan__Loan_Disbursal_Transaction__c ldt;
        INV_DM_MigrationHandler dmHandler = new INV_DM_MigrationHandler();
        List<loan__Loan_Disbursal_Transaction__c> ldtList = new List<loan__Loan_Disbursal_Transaction__c>();
        if(!dm_ldt.isEmpty()){
            for(dm_Loan_Disbursal_Transaction__c dmldt : dm_ldt){
                ldt = dmHandler.DM_StaticFieldMapping_ldt(dmldt,parentId);
                if(ldt<>null)
                    ldtList.add(ldt);
            }//END For 
            try{
                if(!ldtList.isEmpty()){
                    //Create SavePoint
                    insert ldtList;
                }     
            }catch(Exception ex){
                //update the DM Record
                errorUpdate.add(new DM_Loan_Account__c(Id = dmloanID, 
                                                       DM_Error__c = 'Exception Thrown - LDT - '+ ex.getMessage(), 
                                                       DM_valid_Data__c = False, 
                                                       DM_Invalid_Data__c = True, 
                                                       migration_status__c = 'Failed'));                
                Database.rollback(sp);
            }//END Catch   
        }
    }//END insertLDT
    
    private void insertAPS(List<DM_Automated_Payment_Setup__c> dm_APS, Id parentId, Id dmloanID){
        system.debug('inside insertAPS');
        loan__Automated_Payment_Setup__c APS;
        INV_DM_MigrationHandler dmHandler = new INV_DM_MigrationHandler();
        List<loan__Automated_Payment_Setup__c> APSList = new List<loan__Automated_Payment_Setup__c>();
        if(!dm_APS.isEmpty()){
            for(DM_Automated_Payment_Setup__c dmAps : dm_APS){
                APS = dmHandler.DM_StaticFieldMapping_aps(dmAps,parentId);
                system.debug('APS'+aps);
                if(APS<>null)
                    APSList.add(APS);
            }    
            try{
                if(!APSList.isEmpty()){
                    //Create SavePoint
                    system.debug('APS BI');
                    insert APSList;
                }     
            }catch(Exception ex){
                errorUpdate.add(new DM_Loan_Account__c(Id = dmloanID, 
                                                       DM_Error__c = 'Exception Thrown - APS - '+ ex.getMessage(), 
                                                       DM_valid_Data__c = False, 
                                                       DM_Invalid_Data__c = True, 
                                                       migration_status__c = 'Failed'));                          
                Database.rollback(sp);
            }//END Catch   
        }
    }//END insertAPS
    
    private void insertCharges(List<DM_Charge__c> dm_Charges, Id parentId, Id dmloanID){
        system.debug('inside insertAPS');
        loan__Charge__c CHG;
        INV_DM_MigrationHandler dmHandler = new INV_DM_MigrationHandler();
        List<loan__Charge__c> chargeList = new List<loan__Charge__c>();
        if(!dm_Charges.isEmpty()){
            for(DM_Charge__c dmchrg : dm_Charges){
                CHG = dmHandler.DM_StaticFieldMapping_charge(dmchrg, parentId);
                system.debug('CHG'+chg);
                if(CHG <> null)
                    chargeList.add(CHG);
            }    
            try{
                if(!chargeList.isEmpty()){
                    //Create SavePoint
                    system.debug('CHG BI');
                    insert chargeList;
                }     
            }catch(Exception ex){
                errorUpdate.add(new DM_Loan_Account__c(Id = dmloanID, 
                                                       DM_Error__c = 'Exception Thrown - Charges - '+ ex.getMessage(), 
                                                       DM_valid_Data__c = False, 
                                                       DM_Invalid_Data__c = True, 
                                                       migration_status__c = 'Failed'));                          
                Database.rollback(sp);
            }//END Catch   
        }
    }//END insertCharges
    
    private void insertIPT(List<DM_Interest_Posting_Transaction__c> dm_IPT, Id parentId, Id dmloanID){
        system.debug('inside insertAPS');
        loan__Interest_Posting_Transaction__c IPT;
        INV_DM_MigrationHandler dmHandler = new INV_DM_MigrationHandler();
        List<loan__Interest_Posting_Transaction__c> IPTList = new List<loan__Interest_Posting_Transaction__c>();
        if(!dm_IPT.isEmpty()){
            for(DM_Interest_Posting_Transaction__c dmIpt : dm_IPT){
                IPT = dmHandler.DM_StaticFieldMapping_IPT(dmIpt,parentId);
                system.debug('IPT'+ipt);
                if(IPT<>null)
                    IPTList.add(IPT);
            }    
            try{
                if(!IPTList.isEmpty()){
                    //Create SavePoint
                    system.debug('IPT BI');
                    insert IPTList;
                }     
            }catch(Exception ex){
                errorUpdate.add(new DM_Loan_Account__c(Id = dmloanID, 
                                                       DM_Error__c = 'Exception Thrown - IPT - '+ ex.getMessage(), 
                                                       DM_valid_Data__c = False, 
                                                       DM_Invalid_Data__c = True, 
                                                       migration_status__c = 'Failed'));                          
                Database.rollback(sp);
            }//END Catch   
        }
    }//END insertIPT
    
}//END
