/******************************************************************************************************************
* Author: Samar Saha
* Date: Oct - 2019
* Update History - 
*****************************************************************************************************************/ 
Global class INV_DM_MigrationJob implements Database.Batchable<sObject> 
{    
    public String migrationBatchType;
    public static String migrationBatchType;
    public List<DM_Loan_Account__c> errorUpdate = new List<DM_Loan_Account__c>();
  
    global INV_DM_MigrationJob(){
         //call the class and initialize the wrapper instance here.      
    }
    global INV_DM_MigrationJob(String batchType){
        migrationBatchType = batchType;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        INV_DM_SqlQueryGenerator sqlQuery = new INV_DM_SqlQueryGenerator();                        
        return Database.getQueryLocator(sqlQuery.getQueryStringForMigrationStart());
    }

    global void execute(Database.BatchableContext BC, List<DM_Loan_Account__c> dmList) 
    {
        List<DM_Loan_Account__c> dmLoanScopeList = new List<DM_Loan_Account__c>();
        INV_DM_SqlQueryGenerator sqlQuery = new INV_DM_SqlQueryGenerator();        
        dmLoanScopeList = sqlQuery.getContractsForCurrentMigrationScope(dmList); 
        
        system.debug('*****scope list******'+dmList.size()+ 'list '+dmLoanScopeList);   
                            
        INV_DM_Data_Creation dataCreation;              
        dataCreation = new INV_DM_Data_Creation();
        dataCreation.DataCreation(dmLoanScopeList);
         
        system.debug('*****dataCreation Exit*****');        
    }
    
    global void finish(Database.BatchableContext BC) {
         system.debug('*****Finish DM Tool Migration Job*****');
    }
    
}//Class End