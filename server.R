library(shiny)
library(ggplot2)
library(Hmisc)
library(markdown)

#
# These helper methods are pretty self-explanatory - they just segregate some of the math into an out-of-the-way place.
#

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

#
# The main server function that creates our reactive values. Mostly simple math and a graph; nothing too crazy.
#
svrMortgageCalc <- function(input, output){
	payments <- reactive({NumberOfPeriodsRemaining(input$monthlyPayment, input$interestRate*0.01, input$principal)})
	output$paymentsNeeded <- renderPrint({ifelse(payments() < 1, "The payment parameters are not valid", paste(payments(), "months"))})

	# Final amount paid minus the original principal
	output$interestPaid <- renderPrint({ifelse(payments() < 1, "$0.00", paste("$",round(input$monthlyPayment * payments() - MortgageBalancePaid(input$monthlyPayment, input$interestRate*0.01, input$principal, payments()), 2), sep=''))})

	# A TRUE/FALSE control that lets the UI determine if the graph should be rendered. Not a conventional (or correct) way to do this,
	# but it seems to get the job done. FALSE is an empty string and TRUE is three spaces, both of which will get rendered as nothing on the main form.
	output$plotDone <- reactive({ifelse(payments() < 2, "", "   ")})

	# Our rendering of the bad news
	output$paymentPlot <- renderPlot({
		# This is the plot of how much per each payment is going toward the principal
		df <- data.frame(month=seq(1, payments()))
		df$principalPaid <- input$monthlyPayment*seq(1,payments()) - MortgageBalancePaid(input$monthlyPayment, input$interestRate*0.01, input$principal, seq(1,payments()))
		g <- ggplot(df, aes(x=month, y=principalPaid))
		g <- g + geom_line(size=1.2, col="Blue")
		g <- g + theme(legend.background = element_rect(fill = "#FFFAF0", colour = "#000000"),
					   legend.position = c(1,1),
					   legend.justification = c(1,1),
					   legend.background = element_rect(fill = "#FFFAF0", colour = "#000000"),
					   legend.key = element_rect(fill = "#FFFAF0", colour = "#FFFAF0"),
					   panel.background = element_rect(fill = "#FFFAF0", colour = "#000000"),
					   plot.background = element_rect(fill = "#FFFAF0", colour = "#000000"),
					   panel.grid.major = element_line(colour="#FFDEAD"))
		g <- g + labs(x="Month", y="Total Interest Paid", title="Mortgage Cost Calculator")
		g
	})
}

#
# The driver method for the server-side code
#
shinyServer(
	function(input, output) {
		svrMortgageCalc(input, output)
	}
)