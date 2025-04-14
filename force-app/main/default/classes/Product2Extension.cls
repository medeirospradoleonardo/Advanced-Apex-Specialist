public class Product2Extension {
    
    public List<ProductWrapper> productsToInsert {get;set;}
    
    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }
    
    public void AddRows(){
        for (Integer i=0; i<Constants.DEFAULT_ROWS; i++){
            productsToInsert.add(new ProductWrapper());
        }
    }
    
    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }
    
    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> lOptions = new List<SelectOption>();
        lOptions.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));

        for(PickListEntry eachPicklistValue : Constants.PRODUCT_FAMILY) {
            lOptions.add(new SelectOption(eachPicklistValue.getValue(), eachPicklistValue.getLabel()));
        }

        return lOptions;
    }
    
    public PageReference Save(){
        SavePoint sp = Database.setSavepoint();
        Integer insertedCount = 0;

        try {
            List<Product2> lProducts = new List<Product2>();
            List<PriceBookEntry> lPriceBookEntry = new List<PriceBookEntry>();
            List<ProductWrapper> lProductWrapperFiltered = new List<ProductWrapper>();

            for(ProductWrapper eachPW : productsToInsert) {
                if(!String.isBlank(eachPW.productRecord.Name) && !String.isBlank(eachPW.productRecord.Family) && eachPW.productRecord.Family != Constants.SELECT_ONE && eachPW.productRecord.isActive && eachPW.pricebookEntryRecord.UnitPrice != null && eachPW.pricebookEntryRecord.UnitPrice != 0 && eachPW.productRecord.Initial_Inventory__c != null && eachPW.productRecord.Initial_Inventory__c != 0) {
                    lProductWrapperFiltered.add(eachPW);
                }
            }

            for(ProductWrapper productWrapper : lProductWrapperFiltered) {
                lProducts.add(productWrapper.productRecord);
            }

            List<Database.SaveResult> lSaveResult = Database.insert(lProducts, false);
            
            for(Integer i = 0; i < lSaveResult.size(); i++) {

                if(!lSaveResult[i].isSuccess()) {
                    continue;
                }

                PriceBookEntry pbe = lProductWrapperFiltered[i].pricebookEntryRecord;
                pbe.Product2Id = lSaveResult[i].getId();
                pbe.IsActive = true;
                pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                lPriceBookEntry.add(pbe);

                insertedCount++;
            }
            Database.SaveResult[] pbeSaveResults = Database.insert(lPriceBookEntry, false);

            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();
            addRows();
        } catch (Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }

        return null;
    }
    
    public class ProductWrapper{
        public Product2 productRecord {get; set;}
        public PriceBookEntry pricebookEntryRecord {get; set;}

        public ProductWrapper() {
            productRecord = new product2(Initial_Inventory__c = 0);
            pricebookEntryRecord = new pricebookEntry(Unitprice = 0.0);
        }

    }
    
}