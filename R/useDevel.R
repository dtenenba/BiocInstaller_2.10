.isLatest <-
    function()
{
    pkgVers <- as.character(packageVersion("BiocInstaller"))
    compareVersion(pkgVers, BIOCINSTALLER_LATEST) < 0
}

.biocUpgrade <-
    function()
{
    if (.isLatest())
        .stop("'%s' is the latest version of Bioconductor for this version of R ",
              BIOC_LATEST)

    txt <- sprintf("Upgrade all packages to Bioconductor version '%s'? [y/n]: ",
                   BIOC_LATEST)
    answer <- .getAnswer(txt, allowed = c("y", "Y", "n", "N"))
    if ("y" == answer) {
        .update(TRUE)
        biocLite(character(), ask=FALSE)
    }
}

.isDevel <-
    function ()
{
    pkgVers <- packageVersion("BiocInstaller")
    ((compareVersion(as.character(pkgVers), BIOCINSTALLER_LATEST) > 0) &&
     ((pkgVers$minor %% 2L) == 1L))
}

useDevel <-
    function(devel=TRUE)
{
    if (devel && (BIOC_LEADING == BIOC_LATEST))
        .stop("'devel' requires a more recent R")

    if (devel == .isDevel())
        .stop("version '%s' already in use",
              if (devel) BIOC_LEADING else BIOC_LAGGING)
    .update(devel)
}

.update <-
    function(useLeading)
{
    .dbg("before, version is '%s'", packageVersion("BiocInstaller"))
    bootstrap <-
        function()
    {
        if ("package:BiocInstaller" %in% search())
            detach("package:BiocInstaller", unload=TRUE, force=TRUE)
        ## contribUrl will be in bootstrap's environment
        suppressWarnings(tryCatch({
            install.packages("BiocInstaller", contriburl=contribUrl)
        }, error=function(err) {
            assign("failed", TRUE, "biocBootstrapEnv")
            NULL
        }))
        library(BiocInstaller)
        BiocInstaller:::.updateFinish()
    }
    biocBootstrapEnv <- new.env()
    biocBootstrapEnv[["contribUrl"]] <- .getContribUrl(useLeading)
    .stepAside(biocBootstrapEnv, bootstrap)
}

.updateFinish <-
    function()
{
    failed <- exists("failed", "biocBootstrapEnv")
    detach("biocBootstrapEnv")
    .dbg("after, version is %s", packageVersion("BiocInstaller"))
    vers <- packageVersion("BiocInstaller")
    if (!failed)
        .message("'BiocInstaller' changed to version %s", vers)
    else
        .warning("update failed, using BiocInstaller version '%s'",
                 vers, call.=FALSE)
}
