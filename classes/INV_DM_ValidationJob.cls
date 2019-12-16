/******************************************************************************************************************
* Author: Samar Saha
* Date: Oct - 2019
* Update History - 
*****************************************************************************************************************/ 
Global class INV_DM_ValidationJob implements Database.Batchable<sObject> 
{    
    public String migrationBatchType;
    public static String migrationBatchType;
    public List<DM_Loan_Account__c> validationUpdate = new List<DM_Loan_Account__c>();
    public map<id, DM_Loan_Account__c> loanmap = new map<id,DM_Loan_Account__c>();
    public List<INV_DM_ValidationWrapper> validationWrapperList = new List<INV_DM_ValidationWrapper>();
  
    global INV_DM_ValidationJob(){
         //call the class and initialize the wrapper instance here.
         //configWrapper = ParserUtil.getParser();         
    }
    global INV_DM_ValidationJob(String batchType){
        //configWrapper = ParserUtil.getParser(); 
        //migrationBatchType = batchType;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        INV_DM_SqlQueryGenerator sqlQuery = new INV_DM_SqlQueryGenerator();                
        //return Database.getQueryLocator(sqlQuery.GetQueryStringForValidation('DM_Repayment_Schedule_Summary__c;DM_Repayment_Schedule__c;DM_Loan_Payment_Transaction__c;DM_Automated_Payment_Setup__c;DM_Loan_Disbursal_Transaction__c;DM_Loan_Account__c'));
        return Database.getQueryLocator(sqlQuery.GetQueryStringForValidationStart());
    }

    global void execute(Database.BatchableContext BC, List<DM_Loan_Account__c> dmList) 
    {
        List<DM_Loan_Account__c> dmLoanScopeList = new List<DM_Loan_Account__c>();
        INV_DM_SqlQueryGenerator sqlQuery = new INV_DM_SqlQueryGenerator();         
        dmLoanScopeList = sqlQuery.getContractsForCurrentValidationScope(dmList);
        
        system.debug('scope list '+dmList.size()+ 'list '+dmLoanScopeList);                      
        INV_DM_Validation handler = new INV_DM_Validation();
        validationWrapperList = handler.validateDM(dmLoanScopeList);
        
        For(INV_DM_ValidationWrapper valWrapper : validationWrapperList){
            if(valWrapper.Success){          
                validationUpdate.add(new DM_Loan_Account__c(Id=valWrapper.Id, DM_Valid_Data__c=True, DM_Invalid_Data__c=False));      
                system.debug('validation Wrap Success');
            }else{
                //failed valWrapper send for updation
                system.debug('DM CL contract failed-->'+valWrapper.Id);
                validationUpdate.add(new DM_Loan_Account__c(Id=valWrapper.Id, DM_Error__c= valWrapper.errorMessage, DM_Invalid_Data__c=True, migration_status__c='Failed'));
            }
        }
        system.debug('update validated Record '+validationUpdate);
        //to remove duplicate id issue
        loanmap.putall(validationUpdate);
        if(loanmap.size()>0){
            update loanmap.values();
        }
        /*
        if(!validationUpdate.isEmpty()){
            update validationUpdate; 
        }*/
     
    }
    
    global void finish(Database.BatchableContext BC) {
         system.debug('Finish INV_DM_ValidationJob Batch Job');
    }
    
}//Class End