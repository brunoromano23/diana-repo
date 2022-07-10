public class BatchUpdateAccountDiscountBehavior implements
   Database.Batchable<sObject>, Database.Stateful{
 
 
   public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(
            'SELECT Id, Account__c, Creation_Date__c, Payment_Status__c, ' +
            'Status__c FROM Purchase__c ' +
            'Where Creation_Date__c = LAST_YEAR ' +
            'AND Status__c = \'COMPLETED\' ' + 
            'AND Payment_Status__c = \'PAID\''
        );
   }
    
   public void execute(
                Database.BatchableContext BC,
                List<Purchase__c> scope){
      Purchases.calculateAccountDiscountBehaviorByPurchases(scope);
   }
 
   public void finish(Database.BatchableContext BC){
   }
}
