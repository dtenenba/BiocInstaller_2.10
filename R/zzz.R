## The following values are updated with each bioC release
BIOC_LAGGING <- "2.10"           #  first-for-this-R version of Bioconductor
BIOC_LEADING <- "2.11"           # 'devel' or latest-for-this-R version
BIOC_LATEST <- BIOC_LEADING      # latest 'user' version
BIOC_DEVEL <- "2.12"             # latest 'devel' version
BIOCINSTALLER_LATEST <- "1.6"    # BiocInstaller for BIOC_LATEST
NEXT_R_DEVEL_VERSION <- "2.16.0" # next (not-yet-supported) version of R


## Change when the status of MBNI changes. 
## Make sure this change is propagated to users, even 
## if builds have stopped for a particular version of BioC.
## See biocLite.R:.biocinstallRepos to include / exclude package types
includeMBNI <- TRUE
mbniUrl <- "http://brainarray.mbni.med.umich.edu/bioc"

globalVariables("contribUrl")           # used in 'bootstrap' functions

.onAttach <-
    function(libname, pkgname) 
{
    .message("BiocInstaller version %s, ?biocLite for help",
             packageVersion("BiocInstaller"))
    if (!.isLatest())
        .message("A newer version of Bioconductor is available for this version of R, ?BiocUpgrade for help")
}
