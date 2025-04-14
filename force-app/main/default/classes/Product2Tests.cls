@isTest (seeAllData=true)
private class Product2Tests {

    @isTest 
    private static void Product2Extension_UnitTest(){
        Test.startTest();
        
            PageReference pageRef = Page.product2New;
            Test.setCurrentPage(pageRef);

            Product2 p = new Product2(name = 'Test', isActive = true);
            ApexPages.StandardController stdCon = new ApexPages.StandardController(p);
            
            Product2Extension ext = new Product2Extension(stdCon);

            Assert.areEqual(Constants.DEFAULT_ROWS, ext.productsToInsert.size(), 'O tamanho da lista productsToInsert deveria ser ' + Constants.DEFAULT_ROWS);
            
            ext.addRows(); 

            Assert.areEqual(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size(), 'O tamanho da lista productsToInsert deveria ser ' + Constants.DEFAULT_ROWS * 2);

            for (Integer i=0; i<5; i++) {
                Product2Extension.ProductWrapper wrapper = ext.productsToInsert[i];

                wrapper.productRecord = new Product2(
                    Name = 'Test Product' + i,
                    IsActive = true,
                    Initial_Inventory__c = 20,
                    Family = Constants.PRODUCT_FAMILY[0].getValue()
                );
                
                PriceBookEntry pricebookEntry = new PriceBookEntry();
                pricebookEntry.IsActive = true;
                pricebookEntry.UnitPrice = 10;
                wrapper.pricebookEntryRecord = pricebookEntry;
                
            }
            
            ext.save();
            ext.GetFamilyOptions();
            ext.GetInventory();
        Test.stopTest();
        
        List<Product2> lProduct = [SELECT Id FROM Product2 WHERE IsActive= true AND Name = 'Test Product1'];

        Assert.areEqual(1, lProduct.size(), 'O tamanho da lista createdProducts deveria ser 1');
    }

    @isTest 
    private static void Product2Trigger_UnitTest() {
        Test.startTest();
            Product2 product = new Product2();
            product.Name = 'Test';
            product.Family = 'Dessert';
            product.IsActive = true;
            product.Quantity_Ordered__c = 5;
            product.Initial_Inventory__c = 10;
            insert product;
            
            CollaborationGroup collaborationGroup = new CollaborationGroup();
            collaborationGroup.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
            collaborationGroup.Description = 'Description';
            collaborationGroup.CollaborationType = 'Public';
            insert collaborationGroup;
            
            product.Quantity_Ordered__c = 96;
            update product;
        Test.stopTest();
    } 

}