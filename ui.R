library(bnlearn)
library(shiny)
library(shinydashboard)
library(networkD3)
library(visNetwork)
library(igraph)

navbarPage("Bayesian Network - An Epidemiological Study",inverse=TRUE,
              dashboardBody(id="DB",
                            box(width=12,
                                tabBox(width=12,
                                  tabPanel("Structure Learning",tabName="SL",
                                          box(
                                            title=strong("User Input"),
                                            status="success",
                                            width=3,
                                            wellPanel(
                                              fileInput(
                                                'file',
                                                strong('Upload Dataset'),
                                                accept=c('.csv','text/comma-separated-values')
                                              ),
                                              checkboxInput('header','Header',TRUE),
                                              selectInput(
                                                "algorithm",
                                                h5(strong("Select algorithm for learning bayesian structure")),
                                                c("Hill Climbing"="HC",
                                                  "Incremental Association"="IA")
                                              ),
                                              selectInput(
                                                "method",
                                                h5(strong("Select Scoring Method")),
                                                c("Bayesian Equivalent"="BE",
                                                  "Log Likelihood"="LL"
                                                )
                                              ),
                                              verbatimTextOutput("score")
                                            )
                                          ),
                                          column(
                                            width=12,
                                            box(
                                              title=strong("Bayesian Network"),
                                              status="success",
                                              width=NULL,
                                              #plotOutput("structure")
                                              simpleNetworkOutput("network1")
                                            )
                                          )
                                        ),
                                  tabPanel("Parameter Learning",tabName="PL",
                                           box(
                                             title=strong("User Input"),
                                             status="success",
                                             width=3,
                                             wellPanel(
                                               selectInput(
                                                 "parameter",
                                                 h5(strong("Learn Parameters via")),
                                                 c("Bayesian Estimation"="bayes",
                                                   "Maximum Likelihood Estimation"="mle"
                                                 )
                                               ),
                                               selectInput("plot",label=h5(strong("Plot view")),""),
                                               selectInput("node",label=h5(strong("Node")),"")
                                               )
                                           ),
                                           column(
                                             width=12,
                                             box(
                                               title=strong("Network CPTs"),
                                               status="success",
                                               width=NULL,
                                               plotOutput("cptgraph")
                                             )
                                           )
                                           ),
                                  tabPanel("Bayesian Inference",tabName="BI",
                                           box(
                                             title=strong("User Input"),
                                             status="success",
                                             width=3,
                                             wellPanel(
                                               selectInput("node1",label=h5(strong("Choose first evidence")),""),
                                               conditionalPanel("input.plot=='dotplot'||input.plot=='barchart'",
                                                                selectInput("evidence1",label=h5(strong("value")),"")
                                                                ),
                                               selectInput("node2",label=h5(strong("Choose second evidence")),""),
                                               conditionalPanel("input.plot=='dotplot'||input.plot=='barchart'",
                                                                selectInput("evidence2",label=h5(strong("value")),"")
                                                                ),
                                               selectInput("node3",label=h5(strong("Choose third evidence")),""),
                                               conditionalPanel("input.plot=='dotplot'||input.plot=='barchart'",
                                                                selectInput("evidence3",label=h5(strong("value")),"")
                                               ),
                                               selectInput("event",label=h5(strong("Determine Event")),"")
                                             )
                                          ),
                                          column(
                                            width=12,
                                            box(
                                              title=strong("Evidence --> Event Inference"),
                                              status="success",
                                              width=NULL,
                                              plotOutput("inference")
                                            )
                                          )
                                          )
                                      )
                              )
              )
)
                              
                           