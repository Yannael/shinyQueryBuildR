require("RMySQL")

createDB<-function() {
  data(iris)
  colnames(iris)<-c("sepal_length","sepal_width","petal_length","petal_width","species")
  filters<-getFiltersFromTable(iris)
  save(file='filters.Rdata',filters)
  datadb<-dbConnect(RSQLite::SQLite(), "data/data.db")
  dbWriteTable(datadb,"datatable",iris,row.names=F,overwrite=T)
  dbDisconnect(datadb)
}

loadData<-function(sql) {
  if (sql!="") sql<-paste0("where ",sql)
  datadb<-dbConnect(RSQLite::SQLite(), "data/data.db")
  datacontent<-dbGetQuery(datadb,paste0("select * from datatable ",sql))
  dbDisconnect(datadb)
  datacontent
}


