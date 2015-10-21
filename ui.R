library(shiny)

uiMortgageCalc <- function()
{
	fluidPage(
		titlePanel("XSMC - The eXtremely Simple Mortgage Calculator"),
		column(12,
			sidebarPanel(
				sliderInput('principal', 'Principal (original value of loan)',value = 150000, min = 1000, max = 500000, step = 1000),
				sliderInput('interestRate', 'Interest rate (in %)',value = 5.0, min = 0.1, max = 20.0, step = .01),
				numericInput('monthlyPayment', 'Monthly payment', 750, min = 100, max = 5000, step = 100)
		),
		mainPanel(
			h3('Your Mortgage Information'),
			h4('Payments Needed'),
			verbatimTextOutput("paymentsNeeded"),
			h4('Total Interest Paid'),
			verbatimTextOutput("interestPaid")
		)),
		column(12,uiOutput("plotDone"),
			   conditionalPanel(condition = "output.plotDone == '   '",
			   				 plotOutput("paymentPlot")
		)
		)
	)
}

shinyUI(uiMortgageCalc)
