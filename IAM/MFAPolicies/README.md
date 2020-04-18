The two policies will work together to enforce MFA for your users and allows your IAM users to enable MFA and to
resync their own device when they log into the console. They will be unable to disabled MFA once enabled. This may
be similar to what you are looking for.

**When you create an IAM user, that user will be able to log into the console using their password, but they will be
 unable to perform any actions without first enabling MFA**. Your IAM user will then need to access the IAM console
 , locate their username and then activate MFA. Although the IAM user will be able to see all users, they will not be able to make any changes to the other users.

The policies are called `Force_MFA` which you will need to modify as needed for specific permissions for your users (the policy I provided gives the users full access). This is the policy that prevents the users from doing anything in the console until MFA is enabled. The policy MFA allows the IAM user to manage their own MFA devices. Be sure to edit the MFA policy and change <account-ID> to reflect your account ID.
