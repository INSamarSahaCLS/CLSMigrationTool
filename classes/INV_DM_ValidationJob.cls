/******************************************************************************************************************
* Author: Samar Saha
* Date: Oct - 2019
* Update History - 
*****************************************************************************************************************/ 
Global class INV_DM_ValidationJob implements Database.Batchable<sObject> 
{    
    public List<DM_Loan_Account__c> validationUpdate = new List<DM_Loan_Account__c>();
    public map<id, DM_Loan_Account__c> loanmap = new map<id,DM_Loan_Account__c>();
    public List<INV_DM_ValidationWrapper> validationWrapperList = new List<INV_DM_ValidationWrapper>();
  
    global INV_DM_ValidationJob(){
         //call the class and initialize the wrapper instance here.       
    }
    
    global INV_DM_ValidationJob(String batchType){        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        INV_DM_SqlQueryGenerator sqlQuery = new INV_DM_SqlQueryGenerator();                        
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
                validationUpdate.add(new DM_Loan_Account__c(Id=valWrapper.Id, DM_Valid_Data__c=True, DM_Invalid_Data__c=False, migration_status__c='Validated'));      
            }else{
                //failed valWrapper send for updation
                validationUpdate.add(new DM_Loan_Account__c(Id=valWrapper.Id, DM_Error__c= valWrapper.errorMessage, DM_Invalid_Data__c=True, migration_status__c='Validated'));
            }
        }
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
         system.debug('*****Finish DM Tool Validation Job*****');
    }
    
}//Class End