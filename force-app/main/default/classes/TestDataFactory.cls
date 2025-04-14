public with sharing class TestDataFactory {

    public static CollaborationGroup constructCollaborationGroup(){
        return new CollaborationGroup(
            Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS,
            CanHaveGuests = false,
            CollaborationType = 'Public',
            IsArchived = false,
            IsAutoArchiveDisabled = false
        );
    }

    public static List<Product2> constructProducts(Integer cnt){
        List<Schema.PickListEntry> lPickListEntry = Constants.PRODUCT_FAMILY;
        
        List<Product2> lProduct = new List<Product2>();

        for (Integer i = 0; i < cnt; i++) {
            lProduct.add(new Product2(
                Name = 'Product ' + i,
                Family = lPickListEntry[Math.mod(i, lPickListEntry.size())].getValue(),
                Initial_Inventory__c = 10,
                IsActive = true
            ));
        }

        return lProduct;
    }


    public static List<PricebookEntry> constructPricebookEntries(List<Product2> prods){
        List<PricebookEntry> lPricebookEntry = new List<PricebookEntry>();

        for (Product2 product: prods) {
            lPricebookEntry.add(new PricebookEntry(
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
                Product2Id = product.Id,
                IsActive = true,
                UnitPrice = 1
            ));
        }

        return lPricebookEntry;
    }


    public static List<Account> constructAccounts(Integer cnt){

        List<Account> lAccount = new List<Account>();

        for (Integer i = 0; i < cnt; i++) {
            lAccount.add(new Account(
                Name = 'Account ' + i
            ));
        }

        return lAccount;
        
    }


    public static List<Contact> constructContacts(Integer cnt, List<Account> accts){
        List<Contact> lContact = new List<Contact>();

        for (Integer i = 0; i < cnt; i++) {
            lContact.add(new Contact(
                LastName = 'Contact ' + i,
                AccountId = accts[Math.mod(i, accts.size())].Id
            ));
        }
        
        return lContact;
    }


    public static List<Order> constructOrders(Integer cnt, List<Account> accts){

        List<Order> lOrder = new List<Order>();
        
        for (Integer i = 0; i < cnt; i++) {
            lOrder.add(new Order(
                Name = 'Order ' + i,
                AccountId = accts[Math.mod(i, accts.size())].Id,
                EffectiveDate = Date.today(),
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
                Status = 'Draft'
            ));
        }
        
        return lOrder;
    }


    public static List<OrderItem> constructOrderItems(integer cnt, List<PriceBookEntry> pbes, List<Order> ords){

        List<OrderItem> lOrderItem = new List<OrderItem>();
        
        for (Integer i = 0; i < cnt; i++) {
            lOrderItem.add(new OrderItem(
                OrderId = ords[Math.mod(i, ords.size())].Id,
                PriceBookEntryId = pbes[Math.mod(i, pbes.size())].Id,
                Quantity = Constants.DEFAULT_ROWS,
                UnitPrice = 1
            ));
        }
        
        return lOrderItem;
    }


    public static void insertTestData(Integer cnt){
        insert TestDataFactory.constructCollaborationGroup();
        
        List<Product2> lProduct = TestDataFactory.constructProducts(cnt);
        insert lProduct;
        
        List<PricebookEntry> lPricebookEntry = TestDataFactory.constructPricebookEntries(lProduct);
        insert lPricebookEntry;
        
        List<Account> lAccount = TestDataFactory.constructAccounts(cnt);
        insert lAccount;

        insert TestDataFactory.constructContacts(cnt, lAccount);
        
        List<Order> lOrder = TestDataFactory.constructOrders(cnt, lAccount);
        insert lOrder;
        
        insert TestDataFactory.constructOrderItems(cnt, lPricebookEntry, lOrder);
    }
    
    public static void verifyQuantityOrdered(Product2 pOriginalProduct, Product2 pUpdatedProduct, Integer pQtdOrdered){
        Integer sumQuantity = Integer.valueOf(pOriginalProduct.Quantity_Ordered__c) + pQtdOrdered;

        Assert.areEqual(sumQuantity, pUpdatedProduct.Quantity_Ordered__c, 'A quantidade deveria ser ' + sumQuantity);
    }    

}