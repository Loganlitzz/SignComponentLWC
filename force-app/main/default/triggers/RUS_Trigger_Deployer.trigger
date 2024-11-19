trigger RUS_Trigger_Deployer on RollUpSummary_Setup__c (after insert,after update) {
	if(Trigger.isInsert && Trigger.isafter)
    {
        RUS_Api_Creation.createCustomField(trigger.new[0].Parent_Object__c, trigger.new[0].Resultant_Field_Name__c, 'fieldType');
		RUS_Api_Creation.deployTrigger(Trigger.new[0].Child_Object__c,'Name');
		
    }
    if(Trigger.isUpdate)
    {
		//for field modifications
    }
}