library(shiny)
library(DT)
library(queryBuildR)

shinyServer(function(input, output, session) {
  
  sessionvalues <- reactiveValues()
  sessionvalues$data<-loadData("")
  
  observe({
    if (length(input$queryBuilderSQL)>0)
      sessionvalues$data<-loadData(input$queryBuilderSQL)
  })

  output$sqlQuery<-renderText({
    sql<-""
    if (length(input$queryBuilderSQL)>0) {
      if (input$queryBuilderSQL!="")
        sql<-paste0("where ",input$queryBuilderSQL)
    }
    paste0("select * from datatable ",sql)
  })
  
  output$queryBuilderWidget<-renderQueryBuildR({
    data<-sessionvalues$data
    load("filters.Rdata")
    rules<-NULL
    queryBuildR(rules,filters)
  })
  
  output$table<-renderDataTable({
    data<-sessionvalues$data
    colnames(data)<-as.vector(sapply(colnames(data),idToName))
    action <- dataTableAjax(session, data,rownames=F)
    datatable(data, rownames=F, 
              options = list(
                        dom= 'itp',
                        ajax = list(url = action)
                      )
    )
  }, server = TRUE)
})
