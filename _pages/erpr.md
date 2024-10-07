---
layout: archive
title: "erpR"
permalink: /erpr/
author_profile: true
redirect_from:
  - /erpr
---

{% include base_path %}


<img title="erpR" alt="erpR package" src="/files/topoplot and erp.png" width="800">


# What is erpR?

erpR is an R package for fast and easy ERP analysis and graphics. The package provides a series of functions for importing ERP data, exploratory analyses, computing traditional ERP measures and plotting. erpR works on data on which the necessary pre-processing (filtering, epoching, etc.) has already been performed. This is still a beta version (use it with caution and please report bugs).


# Installing erpR
First install the latest version of R. You can download it here. If you want to download the latest version of erpR please type this code on R prompt.
(**NOTE**: you can also find erpR on CRAN site, but that is not the most updated version).

First you must install stringr package and then you may install erpR

`install.packages("stringr")`
`install.packages("erpR", repos="http://R-Forge.R-project.org")`


Please notice that to use the topoplot function of erpR you must install separately the package akima.


`install.packages("akima")`


Unlike erpR, that is released with a GNU license, akima is released with a restricted license, and cannot be used for commercial purposes.


Additional resources for erpR

SAMPLE MATERIAL

[`erpR_sample_pipeline_2018.R`](/files/erpR_sample_pipeline_2018.R) is a file containing an example of an erpR pipeline.

[`erpR_sample_files.zip`](/files/erpr_sample_files.zip) is a zipped folder containing several sample .txt files to be imported on erpR
(notice that the package already contains the same datasets, the .txt files allow to better understand how importing works on erpR).


## EEGLAB
For users who did the pre-precessing with EEGLAB, the eeglb2erpR function, which export eeglab data directly in erpR format.
Check the help of the function for further information.

[`eeglab2erpR.m`](/files/eeglab2erpR.m)  is a function to export an eeglab dataset to files ready to be imported in erpR
(30/04/2016)

[`export_loop_eeglab2erpR.m`](/files/export_loop_eeglab2erpR.m) this little script explains how export multiple EEGLAB datasets in a single take, with a single loop.
(22/02/2019)



## BRAINSTORM
If you did your pre-precessing with BRAINSTORM, you can use the the export_to_erpR custom process.
(Please read here how to use add this process to brainstorm [http://neuroimage.usc.edu/brainstorm/Tutorials/TutUserProcess)](http://neuroimage.usc.edu/brainstorm/Tutorials/TutUserProcess)).
The export_to_erpR process will appear under a new "Giorgio" tab ( Run - Giorgio - export to erpR).
You can also use this process to export results from a Time Frequency analysis (using just one frequency or an average frequency band).

process_export_erpR.m .a brainstorm process to export from brainstorm average data to erpR format.
(03/08/2018)




## Citing erpR

If you use erpR, please cite the package on your work:

*Arcara G., and Petrova A. (2014). erpR: ERP analysis, graphics and utility functions. R package version 0.2.0*



## Bugs and suggestions

If you find a bug on erpR, or if you have any suggestion, please send an e-mail to giorgio.arcara@gmail.com