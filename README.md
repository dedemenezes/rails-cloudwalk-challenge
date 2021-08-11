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

However, cancellations usually don't have a negative influence on the merchant business. A business usually has a cancellation policy, maybe a time period when the customer is allowed to return, the merchant can offer the customer a store credit as well. There are diiferent policies to satisfy it's customers and avoid chargebacks.
 

## Q2 - Get your hands dirty

### Using this csv with hypothetical transactional data, imagine that you are trying to understand if there is any kind of suspicious behavior.

#### Analyze the data provided and present your conclusions (consider that all transactions are made using a mobile device).
Looking at all chargebacks present on the data we can see that almost 50% of it is coming from Visa cards.

Analyzing the data provided you can find different patterns of fraud. Each one with it's own weakness point
#### In addition to the spreadsheet data, what other data would you look at to try to find patterns of possible frauds?


## Q3 - Solve the problem

### An Anti-fraud works by receiving information about a transaction and inferring whether it is a fraudulent transaction or not before authorizing it. We work mostly with Ruby and Python, but you can use any programming language that you want.

### Please use the data provided on challenge 2 to test your solution. Consider that transactions with the flag has_cbk = true are transactions with fraud chargebacks.

Transaction data need to be transformed in order to have a solid bahavioral analysis system.
1. Transaction date will be separated in two columns.
  1.1. DURING_WEEKEND (0 if transaction during a weekday, 1 if transaction during a weekend)
  1.2. DURING_NIGHT (0 if transaction between 6am and 0pm, 1 if transaction between 0pm and 6am)
2. Customer ID will be transformed in six new fields, paired per window. Windows will be 1, 7 and 30.
  ** Filter by 1, 7 and 30 days window
  range = ((date.beginning_of_day)..((date + 6.day).end_of_day))
  ** Count transaction on each window
  ** Sum all transaction on each window
  ** AVG.amount for each window
  
  number of transactions that occur within a time window 
  average amount spent in these transactions
  2.1. user_nb_tx_nDay_window (Number of transactions by the customer in the last n days)
  2.2. user_avg_amount_nDay_window (Average spending amount in the last n days). 

3. Merchant ID will be transform in six new fields, paired per window.
  Here is where we should consider that each chargeback took some time to be received by the system. We need to apply a delay to the time window.  d will be the delay applied because fraudulent transactions are only discovered a few days after the payment was already proccessed.
  Basic delay time would be one week.

  ##### pseudocode
  1. for delay period
  1.1. get number of merchant transactions 
  1.2. get number of transactions with chargeback true
  2. for window period
  2.1.1. window period will be window size + delay period
  2.1. get number of transactions
  2.2. get number of transactions with chargeback true
  3. Calculate Risk
  3.1. Number of transactions during window period will be 2.1 - 1.1
  3.2. Number offraudulent transactions during window period will be 2.2 - 1.2
  3.3. Merchant risk will be 3.2 / 3.1

  delay_period:
  merchant_nb_tx_delay
  MERCHANT_NB_TX_DELAY (Number of transactions on the terminal in the last d days)
  MERCHANT_NB_FRAUD_DELAY (Number of fraudulents transaction on the terminal in the last d days)
  window_period:
  MERCHANT_NB_TX_DELAY_WINDOW (Number of transactions on the terminal in the last n+d days)
  MERCHANT_NB_FRAUD_DELAY_WINDOW (Number of frauds on the terminal in the last n+d days)

  MERCHANT_NB_FRAUD_WINDOW=MERCHANT_NB_FRAUD_DELAY_WINDOW-MERCHANT_NB_FRAUD_DELAY
  
  MERCHANT_NB_TX_WINDOW=MERCHANT_NB_TX_DELAY_WINDOW-MERCHANT_NB_TX_DELAY
  MERCHANT_RISK_WINDOW=MERCHANT_NB_FRAUD_WINDOW/MERCHANT_NB_TX_WINDOW

  Can also return the number of transaction for each window size

### Your Anti-fraud must have at least: 1 endpoint that receives transaction data and returns a recommendation to “approve/deny” the transaction.
* Accept post request with transaction information
  {
  "transaction_id" : 2342357,
  "merchant_id" : 29744,
  "user_id" : 97051,
  "card_number" : "434505******9116",
  "transaction_date" : "2019-11-31T23:16:32.812632",
  "transaction_amount" : 373,
  "device_id" : 285475
  }
#### Antifraud Requirements
* Reject transaction if user is trying too many transactions in a row;

* Reject transactions above a certain amount in a given period;
* Reject transaction if a user had a chargeback before (note that this information does not comes on the payload. The chargeback data is received days after the transaction was approved)
 First need to test for some rules using the transformed data. 
 simple rules to be used:
 * frauds on weekends agains frauds on weekdays
 * frauds on weeknight against frauds on daylight
 * 