Admin account:
login: admin
password: admin

Same for other users.

Usage.
1 Roles.

1.1 There are 3 groups of users in the system: Administrators, auctioneers, and bidders.

- Administrators can create users and roles, and assign roles to users.
- Auctioneers can create auctions, create lots for a auction, manage auction status: started/closed.
- Bidders can leave bids for lots in auctions.

2 Auctions

2.1 Auctions have 3 statuses: not started, started, and closed.
- If auction is not started, auctioneer can manage auction lots until auction status is changed to started. 
- Bidders can leave bid for a started auction's lots. Auctioneer can close auction by changing auction status to closed.
- After auction is closed, all auction lots is processed. If auction lot has bids associated to it, then status of this lot is 
set to sold. Also bidder can't leave bids for a closed auction's lots.

3 Lots and Bids

3.1	At the beginning all lots have their starting price. Bidders can leave bids for a lot therefore increasing a lot sum price by bid price. Sum price of a lot is calculated as lot's starting price plus sum of lot's bid prices.
