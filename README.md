# Morrowind: Restocking Ingredients

A simple data dump with a sprinkle of JS magic to enable searching for restocking ingredients within location.

The original [UESP](https://en.uesp.net/wiki/Morrowind:Restocking_Alchemy_Merchants) page only contains what you can cook in a particular merchant, but sometimes you have two merchants close together that could have required ingredients for even more potions.

## How to use

Go to the website: [https://j-moravec.github.io/morrowind-ingredients](https://j-moravec.github.io/morrowind-ingredients) or copy the file `restocking_ingredients.html` and open it in your web browser.

Simply use the provided search boxes to narrow down your search to a particular **effect** and **location**. This will tell you e.g., if you can mix the effect of interest within *Balmora Temple*, or you need to include *Balmora Mage's guild* as well.

**Click** on the **waffle menu** to show how much merchants restock, and the ingredient cost and weight. These might be important secondary factors.

## How is it made

The UESP HTML was parsed using the R's ancient package `XML`.
The page itself was then generated using a combination of `litedown` together with the JS library `simpleDatatables`.

A simple `makefile` is then provided to run it all, note the fun feature where the makefile runs the R code directly since we use `Rscript` as a shell.
