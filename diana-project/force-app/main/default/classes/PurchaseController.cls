public class PurchaseController {

    public static void calculateAccountDiscountBehaviorByPurchases(List<Purchase__c> purchases) {
        
        Map<Id, List<Boolean>> mapAccountListDiscount = returnMapAccountListAccount(purchases);
        Map<Id, Boolean> mapAccountBuyMoreWithDiscount = returnMapAccountBuyMoreWithDiscount(mapAccountListDiscount); 
        
        List<Account> accountsToUpdate = [Select Id, Buy_Using_Mainly_Discount__c From Account Where Id in: mapAccountBuyMoreWithDiscount.keySet()];
        for(Account account : accountsToUpdate){
            account.Buy_Using_Mainly_Discount__c = mapAccountBuyMoreWithDiscount.get(account.Id);
        }
        update accountsToUpdate;
    }

    private static Map<Id, List<Boolean>> returnMapAccountListAccount(List<Purchase__c> purchases){
        Set<Id> idsPurchases = new Set<Id>();
        for(Purchase__c purchase : purchases){
            idsPurchases.add(purchase.Id);
        }
        Map<Id, List<Boolean>> mapAccountListDiscount = new Map<Id, List<Boolean>>();
        List<Purchase_Line__c> purchaseLines = [Select Id, Purchase__c, Purchase__r.Account__c, 
                                               Original_GrossPrice__c, Adjusted_GrossPrice__c From Purchase_Line__c
                                               Where Purchase__c in: idsPurchases
                                               Order By Purchase__c];
                                                                                      
        for(Purchase__c purchase : purchases){
            List<Boolean> productsHasDiscounts = new List<Boolean>();
            for(Purchase_Line__c purchaseLineItem : purchaseLines){
                if(purchaseLineItem.Purchase__c == purchase.Id){
                    if(purchaseLineItem.Original_GrossPrice__c > purchaseLineItem.Adjusted_GrossPrice__c){
                        productsHasDiscounts.add(true);
                    }
                    else {
                        productsHasDiscounts.add(false);
                    }
                }                
            }
            if(!mapAccountListDiscount.containsKey(purchase.Account__c))
            {
                mapAccountListDiscount.put(purchase.Account__c, productsHasDiscounts);
            }
            else{
                List<Boolean> productsHasDiscountExists = mapAccountListDiscount.get(purchase.Account__c);
                productsHasDiscountExists.addAll(productsHasDiscounts);       
                mapAccountListDiscount.put(purchase.Account__c, productsHasDiscountExists);
            }
        }
        return mapAccountListDiscount;
    }

    private static Map<Id, Boolean>  returnMapAccountBuyMoreWithDiscount(Map<Id, List<Boolean>> mapAccountListDiscount){
        Map<Id, Boolean> mapAccountBuyMoreWithDiscount = new Map<Id, Boolean>();
        for(Id idAccount : mapAccountListDiscount.keySet()){
            List<Boolean> listHasDiscounts = mapAccountListDiscount.get(idAccount);
            Integer countWithDiscount = 0;
            Integer countGrossPrice = 0;
            for(Boolean hasDiscounts : listHasDiscounts){
                if(hasDiscounts)
                    countWithDiscount = countWithDiscount + 1;
                else
                    countGrossPrice = countGrossPrice + 1;
            }
            mapAccountBuyMoreWithDiscount.put(idAccount, countWithDiscount > countGrossPrice ? true : false);  
        }
        return mapAccountBuyMoreWithDiscount;
    }
}
