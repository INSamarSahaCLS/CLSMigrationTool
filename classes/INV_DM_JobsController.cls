/******************************************************************************************************************
* Author: Samar Saha 
* Date: Nov - 2019
* Update History - 
*****************************************************************************************************************/ 
public class INV_DM_JobsController {
    public Integer batchSize{get;set;}
    public Integer instanceNo{get;set;}
    
    public Boolean batchStatusBool {get;set;}
    public String batchStatus {get;set;}  
    Id batchId;  
    public Boolean pollerBool {get;set;}
    
    public INV_DM_JobsController(){
        //initialize with default 200 batchsize
        batchSize = 200;
        instanceNo = 1;
        batchStatusBool = false;
        pollerBool = false;
    }
    
    //pageRef method to run validation batch job from UI button
    public PageReference runValidationJob() {
        batchStatusBool = true;
        for(Integer i = 1; i <= instanceNo; i++){
            INV_DM_ValidationJob b = new INV_DM_ValidationJob(); 
            system.debug('instanceNo-->'+i);
            system.debug('batchSize-->'+batchSize);
            batchId = database.executebatch(b, batchSize);
        }
        //checkBatchStatus();
        return null;
    }
      
    //pageRef method to run migration batch job from UI button   
    public PageReference runMigrationJob() {
        batchStatusBool = true;
        for(Integer i = 1; i <= instanceNo; i++){
            INV_DM_MigrationJob b = new INV_DM_MigrationJob();
            system.debug('batchSize-->'+batchSize); 
            batchId = database.executebatch(b, batchSize);
        }
        checkBatchStatus();
        return null;
    }
    
     public void checkBatchStatus() {
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id =: batchId];
        batchStatus = job.Status;
        if(batchStatus == 'Completed') {
            pollerBool = false;
        } else {
            pollerBool = true;
        }
    }
}