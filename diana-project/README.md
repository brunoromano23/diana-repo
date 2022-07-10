# Diana Technical Assessement

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

CRM analyst wants to analyze customers' purchasing habits using the data present in the CRM. Specifically, he wants to analyze whether customers mainly buy products at full price or if they mainly buy them at a discounted price.
This information must be present in the object of each customer in the CRM and must take into account only the data of the orders placed by the customer in the last year.

Create a new custom field in the Account object to store this information.
Calculate the value of this new custom field for every customer.
Keep in mind all the best practices.


## Solution 

Batchable class was implemented to run async way getting records from purchases and calling business Apex Class with the business rules to update the new field in Account object
All developments is listed in package.xml

All classes has Unit Tests ensuring 100% of code coverage and asserting the bussiness rules.
