library(shiny)

MortgageBalancePaid <- function(monthlyPayment, annualInterestRate, principal, monthsPaid) {
	(12 * monthlyPayment/annualInterestRate - principal)*((1 + annualInterestRate/12)^monthsPaid - 1)
}

MortgageBalanceDue <- function(monthlyPayment, annualInterestRate, principal, monthsPaid) {
	(12 * monthlyPayment / annualInterestRate) - (12 * monthlyPayment / annualInterestRate - principal) * (1 + annualInterestRate / 12)^monthsPaid
}

NumberOfPeriodsRemaining <- function(monthlyPayment, annualInterestRate, principal) {
	per <- -1
	if(monthlyPayment > principal*annualInterestRate/12)
		per <- ceil((log(monthlyPayment) - log(monthlyPayment - principal*annualInterestRate/12)) / log(1+annualInterestRate/12))

	per
}

svrMortgageCalc <- function(input, output){
	payments <- reactive({NumberOfPeriodsRemaining(input$monthlyPayment, input$interestRate*0.01, input$principal)})
	output$paymentsNeeded <- renderPrint({ifelse(payments() < 0, "The payments are not large enough to pay the interest", payments())})

	# Final amount paid minus the original principal
	output$interestPaid <- renderPrint({ifelse(payments() < 0, "0.00", input$monthlyPayment * payments() - input$principal)})

	output$plotDone <- reactive({ifelse(payments() < 0, "", "Payment Schedule")})

	# Our rendering of the bad news
	output$paymentPlot <- renderPlot({
		# This is the plot of how much per each payment is going toward the principal
		plot(x=seq(1, payments()), y=input$monthlyPayment*seq(1,payments()) - MortgageBalancePaid(input$monthlyPayment, input$interestRate*0.01, input$principal, seq(1,payments())))
	})
}


shinyServer(
	function(input, output) {
		svrMortgageCalc(input, output)
	}
)