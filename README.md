# CLSMigrationTool

1. Do assign permission set - DM_Staging_Object_Access to the user who is going to run this tool.
2. Use Batch Size - 200 for Validation Job and Batch Size - 10 for migration job.
3. Make below setting changes in custom setting - DM Tool Settings
    Migrate Amort Schedule? - True (To control if Amort schedule needs to be part of migration process)
    Migrate RSS Schedule? - True  (To control if RSS schedule needs to be part of migration process)
    Enable Strategy-0? - True (To control if we follow strategy 0 for migration process where data is migrated else data is internally                                    generated)
4. Disable Triggers from custom setting - Org Parameters from Loan package.
5. Enable triggers back once the migration is completed.
