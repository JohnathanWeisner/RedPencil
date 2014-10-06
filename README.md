RedPencil
=========

Red Pencil Kata
For up to date tasks check out the trello board 

https://trello.com/b/6ruhJ5FV/red-pencil-kata

#User stories
##~~A red pencil promotion starts due to a price reduction. The price has to be reduced by at least 5% but at most bei 30% and the previous price had to be stable for at least 30 days.~~
####Finished this story

##A red pencil promotion lasts 30 days as the maximum length.
####Not Started

##If the price is further reduced during the red pencil promotion the promotion will not be prolonged by that reduction.
####Not Started

##If the price is increased during the red pencil promotion the promotion will be ended immediately.
##Created method price_increased? on Product model to check for this condition. Add this check to the before_save callback

##If the price if reduced during the red pencil promotion so that the overall reduction is more than 30% with regard to the original price, the promotion is ended immediately.
####Check the price at the start of the sale against the price the product is changing to and use the price_chane_threshold? method

##After a red pencil promotion is ended additional red pencil promotions may follow – as long as the start condition is valid: the price was stable for 30 days and these 30 days don’t intersect with a previous red pencil promotion.