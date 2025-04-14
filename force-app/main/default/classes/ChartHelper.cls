public without sharing class ChartHelper {

    @AuraEnabled
    public static List<ChartData> GetInventory(){
        List<ChartData> lChartData = new List<ChartData>();

        for(AggregateResult aggregateResult : [SELECT Family, SUM(Quantity_Remaining__c) FROM Product2 WHERE Quantity_Remaining__c > 0 AND IsActive = true GROUP BY Family]){
            lChartData.add(new ChartData(String.valueOf(aggregateResult.get('Family')), Integer.valueOf(aggregateResult.get('expr0'))));
        }

        return lChartData;
    }

    public class ChartData {
        public String name {get; set;}
        public Decimal val {get; set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }

}