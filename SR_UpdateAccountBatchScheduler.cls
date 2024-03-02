global class SR_UpdateAccountBatchScheduler implements System.Schedulable{
    global void execute(SchedulableContext sc){
        SR_UpdateAccountBatch accBatch = new SR_UpdateAccountBatch();
        Id jobId = Database.executeBatch(accBatch, 500);
        System.debug('Job Id => '+jobId);
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJOb WHERE Id =: jobId];
        System.debug('Job Details => '+job);
    }
}