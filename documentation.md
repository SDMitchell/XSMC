---
title: "documentation.md"
author: "SDMitchell"
date: "October 20, 2015"
output: html_document
---

**Welcome to the eXtremely Simple Mortgage Calculator (XSMC for short)!** When looking at a mortgage, it is always important to not only know if you can afford the month-to-month payments, but also to realize just how much the mortgage will cost you in interest over the entirety of the loan. The XSMC application is here to help - just set the input dials to the numbers you have and weep at the results!

***

Input                    | What It Does
-------------------------|-------------------------
*Principal*              | This is the original loan amount in dollars
*Interest Rate*          | The interest rate in percent. So if your mortgage interest rate is 4%, set this to 4% (don't worry about the math is all we're saying here)
*Monthly Payment*        | The amount you plan on paying each month. You need to set this amount high enough to at least cover the interest payments (plus a bit) or the application will tell you that the loan parameters are invalid

***

Output                   | What It Means
-------------------------|-------------------------
*Payments Needed*        | This is the number of months it will take you to pay off your mortgage in full using the numbers you've chosen
*Total Interest Paid*    | This is the amount of interest you will have paid on top of the principal amount when the mortgage has been completely paid off
*The Graph*              | This is the total amount of interest that has been paid over time. It is more for looks than it is for usefulness because graphs are cool.

***

**Please note that there could be some rounding errors and such with the final payment amount - this is about the application, not about correctness of the business logic. Don't use this application for anything legally binding either - I'm not responsible if you use this information for anything serious or silly!**
