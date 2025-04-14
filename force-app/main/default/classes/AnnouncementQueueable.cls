public class AnnouncementQueueable implements Queueable  {

    public List<ConnectApi.AnnouncementInput> toPost;

    public void execute (QueueableContext context) {
        PostAnnouncements(toPost);
    }

    public static void postAnnouncements(List<ConnectApi.AnnouncementInput> announcements){
        while (announcements.size() > 0){
            if (Limits.getDMLStatements() >= Limits.getLimitDMLStatements() || Test.isRunningTest()){
                
                break;
            } 

            ConnectApi.AnnouncementInput a = announcements.remove(0);
            ConnectApi.Announcements.postAnnouncement('Internal', a);
        }

        if (announcements.isEmpty() || Test.isRunningTest()){
            return;
        }

        AnnouncementQueueable q = new AnnouncementQueueable();
        q.toPost = announcements;

        System.enqueueJob(q);
    }

}