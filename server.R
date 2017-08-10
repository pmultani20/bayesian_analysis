library(bnlearn)
library(shiny)
library(shinydashboard)
library(networkD3)
#library(igraph)
library(visNetwork)
library(zoom)
library(TeachingDemos)

options(shiny.maxRequestSize=10*1024^2)

shinyServer(function(input,output,session)
  {
  data=reactive({
    fileUpload=input$file
     if(is.null(fileUpload))
       return(NULL)
    data=read.csv(fileUpload$datapath,header=input$header)
  })
  
##############################################################################################################
#structure learning
    
  dag=reactive({
    if(input$algorithm=="HC")
      {
      dag=cextend(hc(data()),strict=FALSE)
      }
      else if(input$algorithm=="IA")
      {
      dag=cextend(iamb(data()),strict=FALSE)
      }
    })

## structure for liver fat dataset
  ##output$structure=renderPlot({

  ##graph=data.frame(directed.arcs(dag()))
  ##nodes=data.frame(name=colnames(data()))
     
  ##print(nodes)
  ##print(graph)
  ##g=graph_from_data_frame(graph,directed=TRUE,vertices=nodes)
  ##print(g,e=TRUE,v=TRUE)
  #jpeg(file = "C://Users//multani//myplot.jpeg")
  #pdf(file = "C://Users//multani//myplot.pdf")
  ##plot(g)
  #dev.off()
  ##zoomplot(xlim = 0,ylim = 0)
  ##})
 
## structure for laryngeal cancer dataset
   output$network1=renderSimpleNetwork({
     
   graph=data.frame(directed.arcs(dag()))
   print(graph)
   write.csv(file = "graph1.csv",x = graph)
   simpleNetwork(
    graph,
   zoom=TRUE,
   linkColour="green",
   nodeColour="red",
   fontFamily="sans-serif",
   fontSize=10,
   Source="from",
   Target="to",
   opacity=20
   )
 })
  
  output$score=renderText({
    if(directed(dag()))
        {
        if(input$method=="BE") 
          {
          score(dag(),data(),type="bde")
          }
          else
            {
          score(dag(),data(),type="loglik")
            }
          }
  })
  
##############################################################################################################
#parameter learning
  
  fit=reactive({
    if(directed(dag()))
      {
      fit=bn.fit(dag(),data(),method=input$parameter)
      }
  })
  
  graph=reactive({
    graph=c("Dot Plot"="dotplot","Bar Chart"="barchart")
  })
  
  observe({
    updateSelectInput(session,"plot",choices=graph())
  })
  
  observe({
    updateSelectInput(session,"node",choices=colnames(data()))
  })

  output$cptgraph=renderPlot({
    if(directed(dag()))
      {
      if(input$plot=="dotplot")
        {
        bn.fit.dotplot(fit()[[input$node]])
        }
      else if(input$plot=="barchart") 
        {
        bn.fit.barchart(fit()[[input$node]])
        }
     }
  })
 
###############################################################################################################
#bayesian inference
  
  observe({
    updateSelectInput(session,"node1",choices=names(data()))
  })

  observe({
    updateSelectInput(session,"node2",choices=names(data()))
  })

  observe({
    updateSelectInput(session,"node3",choices=names(data()))
  })

  observe({
    node1evidence=which(colnames(data())==input$node1)
    value1evidence=as.vector(unique(data()[,node1evidence]))
    updateSelectInput(session,"evidence1",choices=value1evidence)
  })

  observe({
    node2evidence=which(colnames(data())==input$node2)
    value2evidence=as.vector(unique(data()[,node2evidence]))
    updateSelectInput(session,"evidence2",choices=value2evidence)
  })

  observe({
    node3evidence=which(colnames(data())==input$node3)
    value3evidence=as.vector(unique(data()[,node3evidence]))
    updateSelectInput(session,"evidence3",choices=value3evidence)
  })

  observe({
    updateSelectInput(session,"event",choices=names(data()))
  })

  output$inference=renderPlot({

    query<<-paste0("(",input$node1,"=='",input$evidence1,"')&(",input$node2,"=='",input$evidence2,"')&(",input$node3,"=='",input$evidence3,"')")
    eventprobability=prop.table(table(cpdist(fit(),input$event,eval(parse(text=query)))))

    barplot(
      eventprobability,
      col="red",
      main="Event Probability",
      xlab="Categories",
      ylab="Probabilities",
      ylim=c(0, 1)
    )
  })
})

