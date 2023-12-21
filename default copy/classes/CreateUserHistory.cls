public with sharing class CreateUserHistory {
    public void handleUpdatedUsers(){
        Set<String> fieldsToTrack = User_History_Fields__mdt.getAll().keySet();
        List<User_History__c> userHistoryInsertList = new List<User_History__c>();
        
        for(User user : (List<User>) Trigger.New){
            User oldUser = (User) Trigger.oldMap.get(user.Id);

            List<String> changedFieldsToRecord = new List<String>();
            for(String changedField : getChangedFields(oldUser, user)){
                if(fieldsToTrack.contains(changedField)){
                    userHistoryInsertList.add(getUserHistory(changedField, user, oldUser));
                }
            }
        }
        insert userHistoryInsertList;
    }

    private Set<String> getChangedFields(User oldRecord, User newRecord) {
        Set<String> changedFields = new Set<String>();
        Set<String> fieldsToIgnore = new Set<String>{
          'CreatedDate','LastModifiedById','LastModifiedDate','SystemModstamp'
        };

        for (String populatedField : newRecord.getPopulatedFieldsAsMap().keySet()) {
            if(fieldsToIgnore.contains(key)) continue;
            if(oldRecord.get(populatedField) != newRecord.get(populatedField)){
                changedFields.add(key);
            }
        }
        return changedFields;
    }

    private User_History__c getUserHistory(String changedField, User newUser, User oldUser){
        return new User_History__c(
            User__c = newUser.Id,
            Old_Value__c = (String) oldUser.get(changedField),
            New_Value__c = (String) newUser.get(changedField),
            Field_API_Name__c = changedField
        );
    }
}

