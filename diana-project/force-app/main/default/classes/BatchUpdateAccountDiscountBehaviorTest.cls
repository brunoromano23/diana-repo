@IsTest
public class BatchUpdateAccountDiscountBehaviorTest {
    @TestSetup
    public static void testSetup() {  
        List<Account> accs = new List<Account>();
        for(Integer i = 0; i < 10; i ++){
            Account acc = new Account();
            acc.LastName =  'LastName 000'+i;
            acc.FirstName =  'Client 0'+i;
            acc.Email_Key__c =  'test'+ i + '@test.com';
            acc.Source__pc = 'E-COMMERCE';
            acc.Billing_Phone__c = '340123123132';
            acc.Registration_Date__pc = Date.today();
            accs.add(acc);
        }
        insert accs;
        
        List<Purchase__c> purchs = new List<Purchase__c>();
        for(Integer x = 0; x < accs.size(); x++){
            for(Integer i = 0; i < 3; i++){
                Purchase__c purch = new Purchase__c();
                purch.Account__c = accs[x].Id;
                purch.Courier__c = 'DHL';
                purch.Creation_Date__c = Date.today().addYears(-1);
                purch.CurrencyIsoCode = 'EUR';
                purch.OrderTotal_GrossPrice__c = 100 + x + i;
                purch.Order_Number__c = 'ORDNUM000'+x+i;
                purch.Payment_Status__c = 'PAID';
                purch.Shipping_GrossPrice__c = 10;
                purch.Status__c = 'COMPLETED';
                purchs.add(purch);
            }
        }
        insert purchs;

        
        List<Purchase_Line__c> purchsItems = new List<Purchase_Line__c>();
        for(Integer x = 0; x < purchs.size(); x++){
            if(x < 13){
                for(Integer i = 0; i < 3; i++){
                    Purchase_Line__c purchItem = new Purchase_Line__c();
                    purchItem.Name = 'T-shirt blue 00' + x + i;
                    purchItem.CurrencyIsoCode = 'EUR';
                    purchItem.Adjusted_GrossPrice__c = 25 + x + i;
                    purchItem.Original_GrossPrice__c = 30 + x + i;
                    purchItem.Order_Detail_Number__c = 'B-ORDLNTIEM00'+x+i;
                    purchItem.Product_Code__c = 'B-CODE00' + x + i;
                    purchItem.Product_Name__c = 'T-shirt blue 00' + x + i;
                    purchItem.Quantity__c = 1;
                    purchItem.Size__c = 'M';
                    purchItem.Purchase__c = purchs[x].Id;
                    purchsItems.add(purchItem);
                }
            }
            else {
                for(Integer i = 0; i < 2; i++){
                    Purchase_Line__c purchItem = new Purchase_Line__c();
                    purchItem.Name = 'T-shirt blue 00' + x + i;
                    purchItem.CurrencyIsoCode = 'EUR';
                    purchItem.Adjusted_GrossPrice__c = 30 + x + i;
                    purchItem.Order_Detail_Number__c = 'B-ORDLNTIEM00'+ x + i;
                    purchItem.Product_Code__c = 'B-CODE00' + x + i;
                    purchItem.Product_Name__c = 'T-shirt blue 00' + x + i;
                    purchItem.Quantity__c = 1;
                    purchItem.Original_GrossPrice__c = 30 + x + i;
                    purchItem.Size__c = 'X';
                    purchItem.Purchase__c = purchs[x].Id;
                    purchsItems.add(purchItem);
                }
            }   
        }
        insert purchsItems;
    }
    @isTest 
    public static void testBatchExecution() {
        Test.startTest();
        BatchUpdateAccountDiscountBehavior uca = new BatchUpdateAccountDiscountBehavior();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        List<Account> accsBuyingGrossPrice  = [Select Id, Buy_Using_Mainly_Discount__c
                                            from Account Where Buy_Using_Mainly_Discount__c = false];

        List<Account> accBuyingDiscountPrice = [Select Id, Buy_Using_Mainly_Discount__c
                                            from Account Where Buy_Using_Mainly_Discount__c = true];
    

        System.assert(accsBuyingGrossPrice.size() == 6);
        System.assert(accBuyingDiscountPrice.size() == 4);    
    }
}