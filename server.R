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
    filters<-getFiltersFromTable(data)
    rules<-NULL
    queryBuildR(rules,filters)
  })
  
  output$table<-renderDataTable({
    data<-sessionvalues$data
    colnames(data)<-as.vector(sapply(colnames(data),idToName))
    action <- dataTableAjax(session, data,rownames=F)
    widget<-datatable(data, 
                      extensions = 'Scroller',
                      server = TRUE, 
                      selection = 'single',
                      rownames=F,
                      escape=T,
                      options = list(
                        dom= 'itS',
                        deferRender = TRUE,
                        scrollY = 335,
                        ajax = list(url = action),
                        columnDefs = list(
                          list(className="dt-right",targets="_all")
                        )
                      )
    )
    widget
  })
  
})
