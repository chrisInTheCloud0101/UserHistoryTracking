@isTest
private class CreateUserHistoryTest {
    @TestSetup
    static void makeData(){
        String profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User user = new User(
            ProfileId = profileId,
            FirstName = 'test',
            LastName = 'test',
            Email = 'fakemail123@fakemail.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'fakemail123@fakemail.com',
            Alias = 'abc',
            AboutMe = 'a'
        );
        insert user;
    }

    @isTest
    private static void user_history_is_created_when_field_updated(){
        
        User user = [SELECT ID, AboutMe FROM User WHERE FirstName = 'test'];
        
        test.startTest();
        user.AboutMe += 'b';
        update user;
        test.stopTest();

        List<User_History__c> userHistories = [SELECT ID, User__c, Old_Value__c, New_Value__c, Field_API_Name__c FROM User_History__c];
        Assert.areEqual(userHistories.size(), 1);

        User_History__c userHistory = userHistories[0];
        Assert.areEqual(userHistory.User__c, user.Id);
        Assert.areEqual(userHistory.Old_Value__c, 'a');
        Assert.areEqual(userHistory.New_Value__c, 'ab');
        Assert.areEqual(userHistory.Field_API_Name__c, 'AboutMe');

    }
}