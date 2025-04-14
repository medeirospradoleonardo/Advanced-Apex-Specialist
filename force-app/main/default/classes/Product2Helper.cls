public class Product2Helper {

    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = :Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST'+ Constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    public static void afterUpdate(List<Product2> newList, List<Product2> oldList){
        List<Product2> needsAnnouncement = new List<Product2>();

        Map<String, Decimal> invetorySettingMdtMap = new Map<String, Decimal>();

        List<Inventory_Setting__mdt> lInventorySettingMDT = [SELECT Id, DeveloperName, Low_Quantity_Alert__c FROM Inventory_Setting__mdt];

        for (Inventory_Setting__mdt invetorySetting : lInventorySettingMDT) {
            invetorySettingMdtMap.put(invetorySetting.DeveloperName, invetorySetting.Low_Quantity_Alert__c);
        }
        
        for (Product2 product2Info : newList) {
            if (invetorySettingMdtMap.get(product2Info.Family) >  product2Info.Quantity_Remaining__c ) {
                needsAnnouncement.add(product2Info);
            }
        }        

        PostAlerts(needsAnnouncement);
    }

    public static void postAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> lContectAPIAnnouncementInput = new List<ConnectApi.AnnouncementInput>();
        for (Product2 p : productList){
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            ConnectApi.AnnouncementInput announcementInput = new ConnectApi.AnnouncementInput();
            
            announcementInput.expirationDate = Date.today().addDays(1);
            
            announcementInput.sendEmails = false;
            
            textSegmentInput.text = p.Name + '' + Constants.INVENTORY_LEVEL_LOW;
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            messageBodyInput.messageSegments.add(textSegmentInput);
            announcementInput.body = messageBodyInput;
            lContectAPIAnnouncementInput.add(announcementInput);
            
        }

        AnnouncementQueueable announcementQueueable = new AnnouncementQueueable();
        announcementQueueable.toPost = lContectAPIAnnouncementInput;
        System.enqueueJob(announcementQueueable);
        
    }
}