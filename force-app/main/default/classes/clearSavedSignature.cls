public without sharing class clearSavedSignature {
    @AuraEnabled
    public static Boolean clearSavedSignature(List<String> ListofContentDocumentIds)
    {
        try{
            System.debug(ListofContentDocumentIds);
            List<ContentDocument> linklis =new List<ContentDocument>();
            String Querystr='Select id,title FROM ContentDocument WHERE ';
            if(!ListofContentDocumentIds.isEmpty()){
            for(String cdl: ListofContentDocumentIds){
                Querystr = Querystr + 'Id = \''+cdl+'\' OR ';
            }
            Querystr = Querystr.removeEnd(' OR ');

			linklis = Database.query(Querystr);
            integer count=0;
            if(!linklis.isEmpty()){
            for(ContentDocument i: linklis)
            {
                List<ContentDocumentLink> cdl=[Select LinkedEntity.id From ContentDocumentLink Where ContentDocument.Id = :i.id];
                if(cdl.size()>1)
                {
                    linklis.remove(count);
                }
                count+=1;
            }
        }
            //linklis=ListofContentDocumentIds;
			system.debug(linklis);
			Delete linklis;
        }
            return true;
        }
        catch(Exception e)
        {
			throw new AuraHandledException(e.getMessage());
        }
    }
}
