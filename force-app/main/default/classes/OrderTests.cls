@isTest
private class OrderTests {
  
    @testSetup 
    static void SetupTestData(){
        TestDataFactory.InsertTestData(1);
    }

    @isTest 
    private static void OrderUpdate_UnitTest() {
        Test.startTest();
        
        Order order = [SELECT Id, Status FROM Order LIMIT 1];
        Product2 product1 = [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];
        
        order.status = Constants.ACTIVATED_ORDER_STATUS;
        update order;
        
        Product2 product2 =  [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];      
        
        Test.stopTest();

        TestDataFactory.VerifyQuantityOrdered(product1, product2, Constants.DEFAULT_ROWS);
    }
    
    
}