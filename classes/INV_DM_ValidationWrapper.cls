/******************************************************************************************************************
* Author: Samar Saha
* Date: Oct - 2019
* Update History - 
*****************************************************************************************************************/ 
Global with sharing class INV_DM_ValidationWrapper 
{ 
    public Id id;
    public Boolean success = false ;
    public String errorMessage;
    
    Global INV_DM_ValidationWrapper(){}
    
    Global INV_DM_ValidationWrapper(Id id, Boolean success, String errorMessage){
        this.id= id; 
        this.success=success;
        this.errorMessage=errorMessage;
    }//END Global INV_DM_ValidationWrapper
}//END DM_ValidationWrapper