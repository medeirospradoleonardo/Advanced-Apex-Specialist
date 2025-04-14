public without sharing class OrderHelper {
    
    public static void AfterUpdate(List<Order> plNewOrders, Map<Id, Order> pmOldOrders){
        Set<Id> sOrderIds = new Set<Id>();
        for (Order order : plNewOrders){
            if ((order.Status != null && pmOldOrders.get(order.Id)?.Status != null) && 
                order.Status == Constants.ACTIVATED_ORDER_STATUS && pmOldOrders.get(order.Id)?.Status != Constants.ACTIVATED_ORDER_STATUS){
                sOrderIds.add(order.Id);
            }
        }
        
        RollUpOrderItems(sOrderIds);
    }
    
    public static void RollUpOrderItems(Set<Id> psOrderIds){
        Map<Id, Product2> mProductById = new Map<Id,Product2>();
        List<Id> lProductIds = new List<Id>();
        
        for(OrderItem item : [SELECT Id, Quantity, Product2Id FROM OrderItem WHERE OrderId IN :psOrderIds]) {
            lProductIds.add(item.Product2Id);
        }
        
       	mProductById = new Map<Id,Product2>([SELECT Id, Quantity_Ordered__c FROM Product2 WHERE Id IN :lProductIds]);

        AggregateResult[] aggregateResult = [SELECT Product2Id, SUM(Quantity) totalQuantity FROM OrderItem WHERE Product2Id IN :mProductById.keySet() GROUP BY Product2Id];
        

        for(AggregateResult result : aggregateResult) {
            mProductById.get((String)result.get('Product2Id')).Quantity_Ordered__c = Integer.valueOf(result.get('totalQuantity'));
        }
        
        update mProductById.values();
    }
    
}