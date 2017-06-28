forward_emails
========


The forward_emails plugin does the following:

1. Check if the email is a reply form one of the PlusPrivacy users to an outside entity. If the recipient address can be decrypted using the PlusPrivacy encryption key, then the current
email is a reply and the information regarding the alias to use and the external entity to relay to are contained in the decrypted string. We also filter the body of the email to replace
references to the real email address of the user with references to the alias. These references are sometimes automatically added by the email clients and would defeat the purpose of the plugin
if not dealt with.
2. If the email is not a reply, check if it is addressed to one of our users by checking if the recipient address is an alias. If that's the case, then relay the email to the real email address and
change the Reply-To header in order to make the replies seem to come from the alias email (see step 1).



Also check if the emails are addressed either support or contact in which case relay to the appropriate email addresses.