trigger ContentDocumentTrigger on ContentDocumentLink (after insert) {
    Set<Id> recordIds = new Set<Id>();
  
  for (ContentDocumentLink record : Trigger.new) {
      recordIds.add(record.Id);
      system.debug(record.Id);
      contentDocVisibilityUpdate.contentLink(record.ContentDocumentId);
  }
}