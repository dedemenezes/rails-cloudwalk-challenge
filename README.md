Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.

# Cloudwalk studies

## Q1 - Understand the Industry

### 1.1 -> Explain the money flow and the information flow in the acquirer market and the role of the main players.
The customer informations is passed to the payment gateweay, which pass it to the acquirer, who pass it to the card provider and to the issuing bank. After validations it goes all the way back, approving or denying the transaction.
The money would flow from the customer account, to the acquirer account and, finally, to the merchant account.

The information flow structure can have some differences from service to service, although they all have some familiar steps. 
Every time a customer runs an online payment, the client sends a request to the merchant's website with the customer-sensitive payment information. The payment gateway captures that information and encrypts it. It's sent to the card processer, who will check the card information within the appropriate bank. On this end of the chain, the bank is responsible for the actual transaction.
After that, the bank response backtracks the whole chain until the payment gateway, the one responsible to notifies the merchant commerce about the response status. That's when the customer will get his client-side announcement about their transaction. 

Acquirer market: 
* Acquirers can be a company or a financial institution. It's has the rights on another company or another company business part. Usually finantial institutions acquirer the rights to the merchant account. The acquirer would manage the whole merchant's account. It would be resposible to transfer the money from customer to merchant account.
* Merchant acquires usually are financial institutions who have relationships with card flag and they act as a third paty comany who has the network to provide online payment methods.
* Merchants are business who sell and buy goods

### 1.2. -> Explain the difference between acquirer, sub-acquirer and payment gateway and how the flow explained in question 1 changes for these players.

The payment gateway's "only" responsibility is to capture and safely transmit the data to the whole payment chain. After the information is checked, it sends the response back to the merchant server in order to communicate with the customer.
It's, basically, the communication server between merchant's checkout and payment institutions

The acquirer is the one responsible for maintaining the merchant account and processing the payments transactions. It can offer one or more types of payment as well. Basically, it is the one who receives this encrypted data and passes it to the card provider and to the issuing bank. After their validation, the acquirer transfer the values received from the customer account to the merchant account, if the transaction is approved.

A sub-acquirer would be like an intermediary between the merchant and the acquirer, as it would also work as a payment processor but maybe not maintaining the merchant's account

### 1.3. -> Explain what chargebacks are, how they differ from cancellations and what is their connection with fraud in the acquiring world.



Chargeback is, basically, the dispute of one transaction. When a customer complains about a transaction with the issuing bank everyone in the chain can be sure that there was a fraud somewhere in the whole system. It could be a mistake on the merchant side by charging a customer twice for the same purchase, it can also be customer complain about a purchase he didn't made. If a chargeback is confirmed, it's usually charged by the acquirer and by the card providers and can lead to some negative influence on the merchatn business because of the confirmation of a fragile payment system.

However, cancellations usually don't have a negative influence on the merchant business. A business usually has a cancellation policy, maybe a period when the customer is allowed to return, sometimes the merchant would give the customer a store credit. There are diiferent policies to satisfy it's customers and avoid chargebacks.
 

## Q2 - Get your hands dirty

### Using this csv with hypothetical transactional data, imagine that you are trying to understand if there is any kind of suspicious behavior.

#### Analyze the data provided and present your conclusions (consider that all transactions are made using a mobile device).
My first idea was to check for 
#### In addition to the spreadsheet data, what other data would you look at to try to find patterns of possible frauds?







 When it happens on the merchant side, usually, it's becuase of fraud on the purchase transaction and in some cases the merchant can have some fees on this type of issue.
Cancellation is something different since almost all the companies have it's own friendly cancellation policy to satisfy it's customers and it may not be charged.









The information flow structure can differ from service to service but I would say that they all have some steps in commom. 
Every time an online payment is executed on the client side, a request is sent to the merchant website with the customer sensitive payment information. The choosen payment gateway for that transaction is responsible for encrypt that data and send it to the card proccesser. The card network check the card information with the bank responsible for that account. After that, the whole chain is backtracked with the bank response.   Each merchat has one or more different payment gateways that the customer can use to make the payment.  merchant acquirer server which will analyze the data and 

* Acquirer can be a company or a financial institution. They obtains the right to another company or business relatioship deal