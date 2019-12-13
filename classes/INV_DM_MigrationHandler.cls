/******************************************************************************************************************
* Author: Samar Saha
* Date: Oct - 2019
* Update History - 
*****************************************************************************************************************/ 
public with sharing class INV_DM_MigrationHandler 
    {
      public static String productType;
      public loan__Loan_Account__c DM_FieldMapping_LoanAccount(DM_Loan_Account__c scope)
      {
        system.debug('Inside DM_FieldMapping_LoanAccount');
        loan__Loan_Account__c con;
        if(scope !=null)
        {
              productType=scope.Product_Type__c;
              con = new loan__Loan_Account__c();
              con.loan__Contact__c = scope.DM_Contact__c;
              con.loan__Account__c = scope.DM_Account__c;
              con.loan__Overdue_Principal__c =  scope.DM_Overdue_Principal__c;
              con.loan__Overdue_Interest__c  =  scope.DM_Overdue_Interest__c;
              con.loan__Contract_Type__c = scope.DM_Contract_Type__c ;
              con.loan__Loan_Product_Name__c = scope.DM_Product__c ;
              con.loan__Product_Type__c = scope.DM_Product_Type__c ;
              con.loan__Loan_Status__c = scope.DM_Loan_Status__c ;
              con.loan__Application_Date__c = scope.DM_Application_Date__c ;
              con.loan__Disbursal_Date__c = scope.DM_Disbursal_Date__c ;
              con.loan__Expected_Disbursal_Date__c = scope.DM_Expected_Disbursal_Date__c ;
              con.loan__Loan_Amount__c =  scope.DM_Loan_Amount__c;
              con.loan__Expected_Repayment_Start_Date__c = scope.DM_Expected_Repayment_Start_Date__c ;
              con.loan__Number_of_Installments__c = scope.DM_Number_of_Installments__c ;
              con.loan__Frequency_of_Loan_Payment__c = scope.DM_Frequency_of_Loan_Payment__c ;
              con.loan__Next_Installment_Date__c =  scope.DM_Next_Installment_Date__c;
              con.loan__Contractual_Interest_Rate__c = scope.DM_Contractual_Interest_Rate__c ;
              con.loan__Interest_Remaining__c = scope.DM_Interest_Remaining__c ;
              con.loan__Fees_Remaining__c =  scope.DM_Fees_Remaining__c;
              con.loan__Principal_Remaining__c = scope.DM_Principal_Remaining__c ;
              con.loan__Rate_Change_Dt_Last__c = scope.DM_Rate_Change_Dt_Last__c;
              con.loan__Oldest_Due_Date__c = scope.DM_Oldest_Due_Date__c;
              con.loan__Pmt_Amt_Cur__c =  scope.DM_Pmt_Amt_Cur__c  ;
              con.loan__Last_Installment_Date__c = scope.DM_Last_Installment_Date__c;
              con.loan__Payment_Amount__c= scope.DM_Payment_Amount__c;
              con.loan__Disbursal_Amount__c= scope.DM_Disbursal_Amount__c;
              con.loan__Disbursed_Amount__c= scope.DM_Disbursed_Amount__c;
              con.loan__Interest_Only_Period__c= scope.DM_Interest_Only_Period__c;
              con.loan__Interest_Type__c= scope.DM_Interest_Type__c;
              con.loan__Payment_Application_Mode__c= scope.DM_Payment_Application_Mode__c;
              con.loan__Time_Counting_Method__c= scope.DM_Time_Counting_Method__c;
              con.loan__Interest_Calculation_Method__c= scope.DM_Interest_Calculation_Method__c;
              con.loan__Last_Accrual_Date__c= scope.DM_Last_Accrual_Date__c;
              con.loan__Next_Due_Generation_Date__c= scope.DM_Next_Due_Generation_Date__c;
              con.loan__Term_Cur__c= scope.DM_Term_Cur__c;
              con.loan__Due_Day__c= scope.DM_Due_Day__c;
              con.loan__Maturity_Date_Current__c= scope.DM_Maturity_Date_Current__c;
              con.loan__Contractual_Due_Day__c= scope.DM_Contractual_Due_Day__c;
              con.loan__First_Installment_Date__c= scope.DM_First_Installment_Date__c;
              con.loan__Second_Installment_Date__c= scope.DM_Second_Installment_Date__c;
              con.loan__Accrual_Start_Date__c= scope.DM_Accrual_Start_Date__c;
              con.loan__Rate_Change_Dt_Next__c= scope.DM_Rate_Change_Dt_Next__c;
              con.loan__Rate_Change_Dt_Last__c= scope.DM_Rate_Change_Dt_Last__c;
              con.loan__Oldest_Due_Date__c= scope.DM_Oldest_Due_Date__c;
              con.loan__Pmt_Amt_Cur__c = scope.DM_Pmt_Amt_Cur__c;
              con.loan__Disbursal_Status__c = scope.DM_Disbursal_Status__c;
              con.loan__Branch__c = scope.DM_Branch__c;
              con.loan__Fee_Set__c = scope.DM_Fee_Set__c;
              con.loan__Reschedule_Option_On_Excess_Payment__c = scope.DM_Reschedule_Option_On_Excess_Payment__c;
              con.loan__Interest_Rate__c = scope.DM_Interest_Rate__c;
              //con.loan__Fee_Remaining__c = scope.DM_Fee_Remaining__c;
              con.loan__Fees_Paid__c = scope.DM_Fees_Paid__c;
              con.loan__Interest_Paid__c = scope.DM_Interest_Paid__c;
              con.loan__Principal_Paid__c = scope.DM_Principal_Paid__c;
              con.loan__Migration_Date__c = scope.DM_Migration_Date__c;
              //con.Is_Migrated__c = True;
              //con.loan__Due_Day__c = scope.DM_Current_Due_Day_Numeric__c;
              con.loan__Second_Installment_Date__c = scope.Second_Payment_Date_Required_for_Twice_p__c;
              con.loan__Balloon_Payment__c = scope.DM_Balloon_Payment__c;             
              scope.DM_Success__c = True ;     
              //con.Sub_Status__c = scope.DM_Collection_Status__c; 
              //con.CreatedById = scope.CreatedById;
              //con.CreatedDate = scope.CreatedDate; 
              con.loan__Interest_estimated__c = scope.DM_Interest_estimated__c;
              con.loan__Borrower_ACH__c = scope.DM_Borrower_ACH__c;
              con.loan__Loan_Account_External_Id__c = scope.DM_Loan_Account_External_Id__c;
              //con.Shortcut_Id__c = scope.DM_Loan_Account_External_Id__c;
              con.loan__Pre_Bill_Days__c = scope.DM_Pre_Bill_Days__c;
              con.loan__APR__c = scope.DM_APR__c;
              //con.loan__Loan_Purpose__c = scope.DM_Purpose__c;              
              con.loan__Interest_Rate_Last__c = scope.DM_Interest_Rate_Last__c;
              con.loan__Delinquency_Grace_Days__c = scope.DM_Delinquency_Grace_Days__c;              
              //con.AgreeCCA__c = scope.DM_AgreeCCA__c;
              //con.AgreeSECCI__c = scope.DM_AgreeSECCI__c;
              //con.ReadCCA__c = scope.DM_ReadCCA__c;              
              //con.ReadSECCI__c = scope.DM_ReadSECCI__c;              
              //DM_DynamicFieldMapping(scope,con,productType);
          }
          return con;
    }//END DM_FieldMapping_LoanAccount
         
    
      
      public loan__Repayment_Schedule__c DM_StaticFieldMapping_RepaySCH(DM_Repayment_Schedule__c scope,Id parentId)
      {
        loan__Repayment_Schedule__c repaySch;
        if(scope !=null)
        {
              repaySch = new loan__Repayment_Schedule__c();
              repaySch.loan__Loan_Account__c = parentId;
              repaySch.loan__Due_Date__c = scope.DM_Due_Date__c;
              repaySch.loan__Due_Principal__c = scope.DM_Due_Principal__c;
              repaySch.loan__Due_Interest__c = scope.DM_Due_Interest__c;
              repaySch.loan__Balance__c = scope.DM_Balance__c;
              //repaySch.Is_Migrated__c = True;
              //repaySch.CreatedById = scope.CreatedById;
              //repaySch.CreatedDate = scope.CreatedDate; 
              //DM_DynamicFieldMapping(scope,repaySch,productType);                    
        }
          return repaySch;
      }//END DM_StaticFieldMapping_RepaySCH  
      
      public loan__Repayment_Schedule_Summary__c DM_StaticFieldMapping_rss(DM_Repayment_Schedule_Summary__c scope,Id parentId)
      {
        system.debug('inside DM_StaticFieldMapping_RSS');
        loan__Repayment_Schedule_Summary__c rps;
        if(scope !=null)
        {
              rps = new loan__Repayment_Schedule_Summary__c();
              rps.loan__RSS_Loan_Account__c = parentId;
              rps.loan__RSS_Seq__c =  scope.DM_RSS_Seq__c;
              rps.loan__RSS_Repayment_Dt__c  =  scope.DM_RSS_Repayment_Dt__c;
              rps.loan__RSS_Repayment_Amt__c  =  scope.DM_RSS_Repayment_Amt__c;
              rps.loan__RSS_No_Of_Pmts__c  =  scope.DM_RSS_No_Of_Pmts__c;
              //rps.Is_Migrated__c = True;
              //rps.CreatedById = scope.CreatedById;
              //rps.CreatedDate = scope.CreatedDate; 
              //DM_DynamicFieldMapping(scope,rps,productType);
        }
          return rps;
      }//END DM_StaticFieldMapping_rss  
      
      public loan__Loan_Payment_Transaction__c DM_StaticFieldMapping_lpt(DM_Loan_Payment_Transaction__c scope,Id parentId)
      {
        system.debug('inside DM_StaticFieldMapping_lpt');
        loan__Loan_Payment_Transaction__c lpt;
        if(scope !=null)
        {
              lpt = new loan__Loan_Payment_Transaction__c();
              lpt.loan__Loan_Account__c = parentId;
              lpt.loan__Payment_Mode__c =  scope.DM_Payment_Mode__c;
              lpt.loan__Transaction_Amount__c  =  scope.DM_Transaction_Amount__c;
              lpt.loan__Receipt_Date__c = scope.DM_Receipt_Date__c;
              lpt.loan__Cleared__c = scope.DM_Cleared__c ;
              lpt.loan__Rejected__c = scope.DM_Rejected__c;
              lpt.loan__Reversed__c = scope.DM_Reversed__c;
              lpt.loan__Principal__c = scope.DM_Principal__c;
              lpt.loan__Interest__c = scope.DM_Interest__c;
              lpt.loan__Fees__c = scope.DM_Fees__c;
              //lpt.Is_Migrated__c = True;              
              lpt.loan__transaction_date__c = scope.DM_Transaction_Date__C;
              lpt.loan__transaction_time__c = scope.DM_Transaction_time__C;
              lpt.loan__Clearing_Date__c = scope.DM_Clearing_Date__c;
              //lpt.CreatedById = scope.CreatedById;
              //lpt.CreatedDate = scope.CreatedDate;
              
              lpt.loan__Sent_to_ACH__c = scope.DM_Sent_to_ACH__c;
              lpt.loan__Sent_To_ACH_On__c = scope.DM_Sent_To_ACH_On__c;
              //lpt.Gocardless_Payment_Reference__c = scope.DM_Gocardless_Payment_Reference__c;
              lpt.loan__Balance__c = scope.DM_Balance__c;
              lpt.loan__Payoff_Balance__c = scope.DM_Payoff_Balance__c;
              
              //lpt.loan__transaction_Creation_Date__c = scope.DM_Transaction_Creation_Date__c;
              //DM_DynamicFieldMapping(scope,lpt,productType);           
        }
          return lpt;
      }//END DM_StaticFieldMapping_lpt  
      
      public loan__Loan_Disbursal_Transaction__c DM_StaticFieldMapping_ldt(DM_Loan_Disbursal_Transaction__c scope, Id parentId)
      {
        system.debug('inside DM_StaticFieldMapping_ldt');
        loan__Loan_Disbursal_Transaction__c ldt;
        if(scope !=null)
        {
              ldt = new loan__Loan_Disbursal_Transaction__c();
              ldt.loan__Loan_Account__c = parentId;
              ldt.loan__ACH_Filename__c =  scope.DM_ACH_Filename__c;
              ldt.loan__Archived__c  =  scope.DM_Archived__c;
              ldt.loan__Bank_Account__c = scope.DM_Bank_Account__c;
              ldt.loan__Check__c = scope.DM_Check__c;
              ldt.loan__Cleared__c = scope.DM_Cleared__c ;
              ldt.loan__Contribution_From_Excess__c = scope.DM_Contribution_From_Excess__c;
              ldt.loan__Custom_Logic__c = scope.DM_Custom_Logic__c;
              ldt.loan__Disbursal_Date__c = scope.Dm_Disbursal_Date__c;
              ldt.loan__Disbursal_Time__c = scope.DM_Disbursal_Time__c;
              ldt.loan__Disbursed_Amt__c = scope.DM_Disbursed_Amt__c;
              //ldt.loan__Loan_Disbursal_Transaction_Type__c = scope.DM_Loan_Disbursal_Transaction_Type__c;
              ldt.loan__Financed_Amount__c = scope.DM_Financed_Amount__c;
              ldt.loan__Interest_Rate__c = scope.DM_Interest_Rate__c;
              ldt.loan__Internal_Accounting_Generated__c = scope.DM_Internal_Accounting_Generated__c;
              ldt.loan__Loan_Snapshot__c = scope.DM_Loan_Snapshot__c;
              ldt.loan__Master_Archive_Object__c = scope.DM_Master_Archive_Object__c;
              ldt.loan__Mode_of_Payment__c = scope.Dm_Mode_Of_Payment__c;
              ldt.loan__Number_Of_Interest_Only_Payments__c = scope.DM_Number_Of_Interest_Only_Payments__c;
              ldt.loan__Reference__c = scope.DM_Reference__c;
              ldt.loan__Rejected__c = scope.DM_Rejected__c;
              ldt.loan__Reversed__c = scope.DM_Reversed__c;
              ldt.loan__Sent_To_ACH__c = scope.DM_Sent_To_ACH__c;
              ldt.loan__Sent_To_ACH_On__c = scope.DM_Sent_To_ACH_On__c;
              ldt.loan__Summary__c = scope.DM_Summary__c;
              ldt.loan__Summary_Record_Id__c = scope.DM_Summary_Record_Id__c;
              ldt.loan__Pre_Paid_Fee__c = scope.DM_Pre_Paid_Fee__c;
              ldt.loan__Refinanced_Amount__c = scope.DM_Refinanced_Amount__c;
              //ldt.Is_Migrated__c = True;
              //ldt.CreatedById = scope.CreatedById;
              //ldt.CreatedDate = scope.CreatedDate;
              
              //ldt.File_Processed__c = scope.DM_File_Processed__c;
              //DM_DynamicFieldMapping(scope,ldt,productType);
        }
         return ldt;
      } 
      
      public loan__Automated_Payment_Setup__c DM_StaticFieldMapping_aps(DM_Automated_Payment_Setup__c scope,Id parentId)
      {
        system.debug('inside DM_StaticFieldMapping_APS');
        loan__Automated_Payment_Setup__c aps;
        if(scope !=null)
        {
              aps = new loan__Automated_Payment_Setup__c();
              aps.loan__CL_Contract__c = parentId;
              aps.loan__Bank_Account__c =  scope.DM_Bank_Account__c;
              aps.loan__Debit_Date__c  =  scope.DM_Debit_Date__c;
              aps.loan__Transaction_Amount__c  =  scope.DM_Transaction_Amount__c;
              aps.loan__Type__c  =  scope.DM_Type__c;
              aps.loan__Amount_Type__c = scope.DM_Amount_Type__c;
              aps.loan__Payment_Mode__c =  scope.DM_Payment_Mode__c;
              aps.loan__Active__c  =  scope.DM_Active__c;
              aps.loan__Frequency__c  =  scope.DM_Frequency__c;
              aps.loan__Debit_Day__c  =  scope.DM_Debit_Day__c;
              aps.loan__Recurring_ACH_Start_Date__c  =  scope.DM_Recurring_ACH_Start_Date__c;
              //aps.Is_Migrated__c = True;
              //aps.CreatedById = scope.CreatedById;
              //aps.CreatedDate = scope.CreatedDate;
              
              aps.loan__Recurring_ACH_End_Date__c = scope.DM_Recurring_ACH_End_Date__c;
              //aps.loan__Second_Payment_Date__c  =  scope.DM_Second_Payment_Date__c;
              //call Method
              //DM_DynamicFieldMapping(scope,aps,productType);
            
        }
          return aps;
      }//END DM_StaticFieldMapping_aps  
      
       public loan__Charge__c DM_StaticFieldMapping_charge(DM_Charge__c scope,Id parentId)
      {
        system.debug('inside DM_StaticFieldMapping_charge');
        loan__Charge__c charge;
        if(scope !=null)
        {
              charge = new loan__Charge__c();
              charge.loan__Loan_Account__c = parentId;
              charge.loan__Date__c =  scope.DM_Date__c;
              charge.loan__Fee__c  =  scope.DM_Fee__c;
              charge.loan__Paid__c = scope.DM_Paid__c;
              charge.loan__Waive__c = scope.DM_Waive__c;
              //charge.loan_payment_Amount__c = scope.DM_payment_Amount__c;
              charge.loan__Original_Amount__c= scope.DM_Original_Amount__c;
              //DM_DynamicFieldMapping(scope,charge,productType);
        }
          return charge;
      }//END DM_StaticFieldMapping_charge
      
      public loan__Interest_Posting_Transaction__c DM_StaticFieldMapping_IPT(DM_Interest_Posting_Transaction__c scope,Id parentId)
      {
        system.debug('inside DM_StaticFieldMapping_charge');
        loan__Interest_Posting_Transaction__c ipt;
        if(scope !=null)
        {
              ipt = new loan__Interest_Posting_Transaction__c();
              ipt.loan__Loan_Contract__c = parentId;
              ipt.loan__Accrued_To_Investor__c =  scope.DM_Accrued_to_Investor__c;
              ipt.loan__Balance__c =  scope.DM_Balance__c ;
              ipt.loan__Is_Capitalized__c = scope.DM_Capitalized__c;
              ipt.loan__Discarded__c = scope.DM_Discarded__c;
              ipt.loan__Due_Amount__c= scope.DM_Due_Amount__c;
              //DM_DynamicFieldMapping(scope,charge,productType);
        }
          return ipt;
      }//END DM_StaticFieldMapping_ipt
    
      /*private void DM_DynamicFieldMapping(Sobject scope, Sobject dmSOBJ,String productType){
        system.debug('Inside DM_DynamicFieldMapping');
        DM_Metadata_Config_Wrapper configWrapper1 = ParserUtil.getParser();  
        system.debug('configWraper'+configWrapper1);
        Map<String, Map<String, String>> JSONFieldMapping =  DM_Validate_Impl.getFieldMappingFromJSON(configWrapper1);
        //Map<SImple Loan|DM_Loan_Acc,Map<srcObject|SrcField,TargetObj+TargetField+DataType>>
        Map<String,String> tempMap = new Map<String,String>();
        string objName;
        Sobject sObj;        
        String[] fieldMetadata;
        String[] temp;
        String srcField;
        objName = String.valueOf(scope).split(':')[0];
        system.debug('objName'+objName);
        system.debug('product type'+productType);
        system.debug('JSON Field Mapping keyset '+JSONFieldMapping.keySet());
        system.debug('JSON Field Mapping keyset '+JSONFieldMapping.values());
        if(JSONFieldMapping.containsKey(productType+'|'+objName.toLowerCase())){
            system.debug('productType|SRCObject Matched');
            tempMap = JSONFieldMapping.get(productType+'|'+objName.toLowerCase());
            system.debug('tempMap size '+tempMap);
            if(tempMap<>null){
                for(String key : tempMap.KeySet()){
                    system.debug('Inside TempMap KeySet');
                    temp = key.split('\\|');
                    system.debug('temp'+temp);
                    srcField=temp[1];
                    system.debug('srcField '+srcField);
                    if(tempMap.get(key)<>null){
                        system.debug('inside tempMap');
                        fieldMetadata = tempMap.get(key).split('\\|');
                        if(scope.get(srcField)<>null){
                            if(dynamicDataTypeCheck(fieldMetadata[2],String.valueOf(scope.get(srcField)))){
                                system.debug('data Type check Succeed');
                                if(fieldMetadata[2]=='Text')
                                    dmSOBJ.put(fieldMetadata[1],String.valueOf(scope.get(srcField)));
                                else if(fieldMetadata[2]=='Date')
                                    dmSOBJ.put(fieldMetadata[1],dynamicDataTypeDateConversion(String.valueOf(scope.get(srcField))));//Date.valueOf(String.valueOf(scope.get(srcField)))
                                else if(fieldMetadata[2]=='Checkbox')
                                    dmSOBJ.put(fieldMetadata[1],dynamicBooleanConversion(String.valueOf(scope.get(srcField))));
                                else if(fieldMetadata[2]=='Number')
                                    dmSOBJ.put(fieldMetadata[1],dynamicNumberConversion(String.valueOf(scope.get(srcField))));        
                            }//DynamicDataTypeCheck 
                        }//END if(scope.get(srcField)<>null){
                    }//END if(tempMap.get(srcField)<>null){
                }//END FOR Loop
            }//IF not null
        }//END IF ContainsKey
     }//END DM_DynamicFieldMapping_Contract    
     */
     
     /*
     private Boolean dynamicDataTypeCheck(String dataType, String value){
         system.debug('inside dynamicDataTypeCheck');
         system.debug('data type '+dataType);
         if(dataType=='Text'){
             return true;
         }
         
         if(dataType=='Date'){
             Pattern pattern =  Pattern.compile('(0?[1-9]|[12][0-9]|3[01])-(0?[1-9]|1[012])-((19|20)\\d\\d)');
             Matcher matcher = pattern.matcher(value);
             return matcher.matches();
         }
         
         if(dataType=='Number'){
             return value.isNumeric();
         }
         
         if(dataType=='Checkbox'){
             if(Value=='True' || Value=='False')
                 return true;
         }
         return false;
     }//END dynamicDataTypeCheck
     */
        
        /*private Date dynamicDataTypeDateConversion(String value){
            Date tempDate;
            String[] dateVal;
            dateVal = value.split('-');
            tempdate = date.newinstance(integer.valueOf(dateVal[2]),integer.valueOf(dateVal[0]),integer.valueOf(dateVal[1]));
            return tempdate;
        }//END dynamicDataTypeDateConversion
        */
        
        /*
        private Boolean dynamicBooleanConversion(String Value){
            if(Value=='True')
                return true;
            else
                return false; 
        }*/
        
        /*
        private Decimal dynamicNumberConversion(String Value){
            Decimal num = Decimal.valueOf(value);
            return num;
        }*/
        
}//END class DM_MigrationHandler