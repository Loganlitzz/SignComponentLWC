//src
trigger Acc_trigger on Account (after insert) {
if(trigger.isafter && trigger.isInsert)
{
S2S_Record_Sync.acc_handler(trigger.newmap);
}
}