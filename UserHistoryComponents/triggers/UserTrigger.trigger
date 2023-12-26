trigger UserTrigger on User (after update) {
    new CreateUserHistory().handleUpdatedUsers();
}