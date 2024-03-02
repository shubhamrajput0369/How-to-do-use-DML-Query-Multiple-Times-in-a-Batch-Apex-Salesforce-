global class SR_UpdateAccountBatch implements Database.Batchable<sObject>,Database.stateful { 
    public static final Set<Id> accIdSet = new Set<Id>();
    
    Static{
        //Step 1: In Static block Query Contact with Records AccountId WHERE Level = 'Primary'
        Map<Id, Contact> resultMap = new Map<Id, Contact>([SELECT Id, AccountId FROM Contact WHERE Level__c = 'Primary' WITH SECURITY_ENFORCED]);
        
        //Step 2: Store AccountId in Set/Map/Any suitable Data Structure which declared as static final.
        for(Contact conObj : resultMap.values()){
            accIdSet.add(conObj.AccountId);
        }
    }
    public SR_UpdateAccountBatch(){
        //Constructor
    }
    public List<Opportunity> oppList = new List<Opportunity>();
    global Database.QueryLocator start(Database.BatchableContext bc){
        //Step 3: In Start block of batch Query Opportunity Record WHERE Stage = 'Value Proposition' AND Asset.Type = 'Technology Partner'
        String query = 'SELECT Id, Discount_Percentage__c, AccountId, Account.type FROM Opportunity WHERE StageName = \'Value Proposition\' AND Account.type = \'Technology Partner\' WITH SECURITY_ENFORCED';
		return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> oppScope){
        //Step 4: Execute the logic only id AccountId is present in Set/Map contains AccountId of Queried Contact records.
        for(Opportunity oppObj : oppScope){
            if(accIdSet.contains(oppObj.AccountId)){
                oppObj.Discount_Percentage__c = 10;
                oppList.add(oppObj);
            }
        }
        if(oppList != null && !oppList.isEmpty()){
            Database.update(oppList, false);
        }
    }
    global void finish(Database.BatchableContext bc){
        //Post operation
    }
}