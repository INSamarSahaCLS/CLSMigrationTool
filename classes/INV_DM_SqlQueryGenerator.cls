/******************************************************************************************************************
* Author: Samar Saha
* Date: Oct - 2019
* Update History - 
    1. Updated code to handle large no of records in batch class.
    2. Updated code to fetch records from Migration_Tool_Configuration__c object
*****************************************************************************************************************/ 
public with sharing class INV_DM_SqlQueryGenerator 
{
    public String getQueryStringForValidationStart(){    
        List<Migration_Tool_Configuration__c> configList = [Select Id, 
                                                             Active__c, 
                                                             Is_Child__c, 
                                                             Object_API_Name__c, 
                                                             Object_Name__c,                                                              
                                                             Query_String__c 
                                                             from Migration_Tool_Configuration__c where 
                                                             Active__c = True 
                                                             and Execute_in_Start__c = True 
                                                             and Job_Type__c = 'Validation'];
                                                             
        return configList[0].Query_String__c;
    }
    
    public String getQueryStringForMigrationStart(){    
        List<Migration_Tool_Configuration__c> configList = [Select Id, 
                                                             Active__c, 
                                                             Is_Child__c, 
                                                             Object_API_Name__c, 
                                                             Object_Name__c,                                                              
                                                             Query_String__c 
                                                             from Migration_Tool_Configuration__c where 
                                                             Active__c = True 
                                                             and Execute_in_Start__c = True 
                                                             and Job_Type__c = 'Migration'];
                                                             
        return configList[0].Query_String__c;
    }
    
    public List<DM_Loan_Account__c> getContractsForCurrentValidationScope(List<DM_Loan_Account__c> dmList)
    {
        List<DM_Loan_Account__c> dmLoanScopeList = new List<DM_Loan_Account__c>();
        string query =''; 
        string parent='';
        string status='Pending';
        
        string parentField = '';
        string parentObjectAPIName = '';
        string finalQuery = '';
        
        List<Migration_Tool_Configuration__c> configList = [Select Id, 
                                                             Active__c, 
                                                             Is_Child__c, 
                                                             Object_API_Name__c, 
                                                             Object_Name__c, 
                                                             Query_Limit__c, 
                                                             Query_String__c 
                                                             from Migration_Tool_Configuration__c where 
                                                             Active__c = True and 
                                                             Execute_in_Start__c = False];
                                                             
        for(Migration_Tool_Configuration__c con : configList){
            if(con.Is_Child__c == True){
                query =  query + '(' + con.Query_String__c + '),';
            }
            else{
                parentField = con.Query_String__c;
                parentObjectAPIName = con.Object_API_Name__c;
                system.debug('*** Parent Object Name for Validation Job ***' + parentObjectAPIName);
            }        
        }
        
        query = query.removeEnd(',');                                       
        /*finalQuery = 'Select '+ parentField + ',' + query + ' from ' + parentObjectAPIName + 
                     ' where Migration_status__c = \'' +status+ '\' '+ 
                     ' and DM_Valid_Data__c = False and Id IN:'+ dmList;  */
                     
        if(query != ''){   
            finalQuery = 'Select '+ parentField + ',' + query + ' from ' + parentObjectAPIName + 
                     ' where Id IN: dmList';
        }else{
            finalQuery = 'Select '+ parentField + ' from ' + parentObjectAPIName + 
                         ' where Id IN: dmList';  
        }
        
        system.debug('*** finalQuery --> ***' + finalQuery );
        
        //return finalQuery;
        dmLoanScopeList = Database.query(finalQuery); 
        return dmLoanScopeList;           
    }
    
    public List<DM_Loan_Account__c> getContractsForCurrentMigrationScope(List<DM_Loan_Account__c> dmList)
    {
        List<DM_Loan_Account__c> dmLoanScopeList = new List<DM_Loan_Account__c>();
        string query ='';
        string parent='';
        string status='pending';
        
        string parentField = '';
        string parentObjectAPIName = '';
        string finalQuery = '';
        
        List<Migration_Tool_Configuration__c> configList = [Select Id, 
                                                             Active__c, 
                                                             Is_Child__c, 
                                                             Object_API_Name__c, 
                                                             Object_Name__c, 
                                                             Query_Limit__c, 
                                                             Query_String__c 
                                                             from Migration_Tool_Configuration__c where 
                                                             Active__c = True and 
                                                             Execute_in_Start__c = False];
                                                             
        for(Migration_Tool_Configuration__c con : configList){
            if(con.Is_Child__c == True){
                query =  query + '(' + con.Query_String__c + '),';
                system.debug('*** query child ***' + query);
            }
            else{
                parentField = con.Query_String__c;
                parentObjectAPIName = con.Object_API_Name__c;
                system.debug('*** Parent Object Name for migration Job ***' + parentObjectAPIName);
            }        
        }
        
        query = query.removeEnd(',');    
        if(query != ''){                                   
            finalQuery = 'Select '+ parentField + ',' + query + ' from ' + parentObjectAPIName + 
                         ' where Id IN: dmList';  
        }else{
            finalQuery = 'Select '+ parentField + ' from ' + parentObjectAPIName + 
                         ' where Id IN: dmList';  
        }
                     
        system.debug('*** finalQuery --> ***' + finalQuery );
        
        //return finalQuery;     
        dmLoanScopeList = Database.query(finalQuery);
        return dmLoanScopeList;                      
    }   
}