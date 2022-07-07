public class UpdateAccountDiscountBehavior implements
   Database.Batchable<sObject>, Database.Stateful{
 
   public final String Query;
   public integer Summary;
   
   public SummarizeAccountTotal(String q){Query=q;
     Summary = 0;
   }
 
   public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }
    
   public void execute(
                Database.BatchableContext BC,
                List<sObject> scope){
      for(sObject s : scope){
         Summary = Integer.valueOf(s.get('total__c'))+Summary;
      }
   }
 
public void finish(Database.BatchableContext BC){
   }
}
