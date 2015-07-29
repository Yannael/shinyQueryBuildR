library(shiny)
library(DT)
library(queryBuildR)

shinyUI(fluidPage(
  includeCSS('www/style.css'),
  fluidRow(
    column(10,offset=1,
           h4("Define and apply filters"),
           queryBuildROutput("queryBuilderWidget",width="800px",height="100%"),
           actionButton("queryApply", label = "Apply filters"),
           tags$div(class="extraspace"),
           h4("Resulting SQL query and table"),
           textOutput("sqlQuery"),
           tags$script('
               function getSQLStatement() {
                   var sql = $("#queryBuilderWidget").queryBuilder("getSQL", false);
                   Shiny.onInputChange("queryBuilderSQL", sql);
               };
               document.getElementById("queryApply").onclick = function() {getSQLStatement()}
           '),
           DT::dataTableOutput('table'),
           tags$div(class="extraspace")
    )
  )
))
