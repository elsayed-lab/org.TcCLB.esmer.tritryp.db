datacache <- new.env(hash=TRUE, parent=emptyenv())

org.TcCLB.esmer.tritryp <- function() showQCData("org.TcCLB.esmer.tritryp", datacache)
org.TcCLB.esmer.tritryp_dbconn <- function() dbconn(datacache)
org.TcCLB.esmer.tritryp_dbfile <- function() dbfile(datacache)
org.TcCLB.esmer.tritryp_dbschema <- function(file="", show.indices=FALSE) dbschema(datacache, file=file, show.indices=show.indices)
org.TcCLB.esmer.tritryp_dbInfo <- function() dbInfo(datacache)

org.TcCLB.esmer.tritrypORGANISM <- "Trypanosoma cruzi"

.onLoad <- function(libname, pkgname)
{
    ## Connect to the SQLite DB
    dbfile <- system.file("extdata", "org.TcCLB.esmer.tritryp.sqlite", package=pkgname, lib.loc=libname)
    assign("dbfile", dbfile, envir=datacache)
    dbconn <- dbFileConnect(dbfile)
    assign("dbconn", dbconn, envir=datacache)

    ## Create the OrgDb object
    sPkgname <- sub(".db$","",pkgname)
    db <- loadDb(system.file("extdata", paste(sPkgname,
      ".sqlite",sep=""), package=pkgname, lib.loc=libname),
                   packageName=pkgname)    
    dbNewname <- AnnotationDbi:::dbObjectName(pkgname,"OrgDb")
    ns <- asNamespace(pkgname)
    assign(dbNewname, db, envir=ns)
    namespaceExport(ns, dbNewname)
        
    packageStartupMessage(AnnotationDbi:::annoStartupMessages("org.TcCLB.esmer.tritryp.db"))
}

.onUnload <- function(libpath)
{
    dbFileDisconnect(org.TcCLB.esmer.tritryp_dbconn())
}

