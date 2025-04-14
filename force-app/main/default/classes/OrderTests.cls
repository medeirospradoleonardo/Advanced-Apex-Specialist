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

    @isTest 
    private static void OrderExtension_UnitTest() {
        PageReference reference = Page.OrderEdit;
        Test.setCurrentPage(reference);

        Order order = [SELECT Id, Status FROM Order LIMIT 1];

        ApexPages.StandardController controller = new Apexpages.StandardController(order);
        OrderExtension extension = new OrderExtension(controller);

        Assert.areEqual(1, extension.orderItemList.size(), 'O tamanho da lista orderItemList deveria ser 1');

        extension.selectedFamily = 'Dessert';
        extension.SelectFamily();
        extension.OnFieldChange();
        extension.First();
        extension.Next();
        extension.Previous();
        extension.Last();
        extension.GetHasNext();
        extension.GetPageNumber();
        extension.GetHasPrevious();
        extension.GetTotalPages();
        extension.GetFamilyOptions();
        extension.Save();
        ChartHelper.GetInventory();
    } 
    
    
}