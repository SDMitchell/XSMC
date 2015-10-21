library(shiny)
library(markdown)

uiMortgageCalc <- function()
{
	# A page with our UI controls and layout on it, including a documentation bar at the top of the page.
	fluidPage(
		titlePanel("XSMC - The eXtremely Simple Mortgage Calculator"),
		column(12,
			tabsetPanel(
			   	tabPanel("XSMC",includeMarkdown("documentation.md")))
		),
		column(12,
			sidebarPanel(
				sliderInput('principal', 'Principal (original value of loan)',value = 150000, min = 1000, max = 500000, step = 1000),
				sliderInput('interestRate', 'Interest rate (in %)',value = 5.0, min = 0.1, max = 20.0, step = .01),
				numericInput('monthlyPayment', 'Monthly payment', 750, min = 100, max = 5000, step = 100)),
			mainPanel(
				h3('Your Mortgage Information'),
				h4('Payments Needed'),
				verbatimTextOutput("paymentsNeeded"),
				h4('Total Interest Paid'),
				verbatimTextOutput("interestPaid"))
		),
		column(12,
			   # I have no idea how to make this hidden graph thing work the "correct" way, so I used this wonderfully shameful idea with
			   # an empty string being FALSE and a string with three spaces being TRUE. Since there is nothing to display, the value doesn't
			   # really show up on the form, even though it is rendered.
			   uiOutput("plotDone"),
			   conditionalPanel(condition = "output.plotDone == '   '", plotOutput("paymentPlot"))
		)
	)
}

#
# Driver for the UI-side code.
#
shinyUI(uiMortgageCalc)
