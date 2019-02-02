*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] patient_info

[Dataset Description] This dataset contains the basic information about patients in the study, including sex, age, weight and race.

[Experimental Unit Description] Each patient in this study

[Number of Observations] 357
                    
[Number of Features] 5

[Data Source] https://semanticommunity.info/@api/deki/files/25541/adverser.xls?origin=mt-web

[Data Dictionary] https://semanticommunity.info/Data_Science/SAS_Public_Data_Sets#Sample_Data_4

[Unique ID Schema] There's one column named patient_id which specifies the identities of patients.
;
%let inputDataset1DSN = patient_info;
%let inputDataset1URL =
https://github.com/yli110-stat697/team-2_project_repo/blob/master/data/patient_info.xlsx?raw=true
;
%let inputDataset1Type = XLSX;


*
[Dataset 2 Name] placebo

[Dataset Description] The dataset contains the recorded adverse reactions of patients in the placebo group.

[Experimental Unit Description] Each patient in this study

[Number of Observations] 130
                    
[Number of Features] 8

[Data Source] https://semanticommunity.info/@api/deki/files/25541/adverser.xls?origin=mt-web

[Data Dictionary] https://semanticommunity.info/Data_Science/SAS_Public_Data_Sets#Sample_Data_4

[Unique ID Schema] There's one column named patient_id which specifies the identities of patients.
;
%let inputDataset2DSN = placebo;
%let inputDataset2URL =
https://github.com/yli110-stat697/team-2_project_repo/blob/master/data/placebo.xlsx?raw=true
;
%let inputDataset2Type = XLSX;


*
[Dataset 3 Name] treatment

[Dataset Description] The dataset contains the recorded adverse reactions of patients in the drug-treated group.

[Experimental Unit Description] Each patient in the study

[Number of Observations] 127
                    
[Number of Features] 8

[Data Source] https://semanticommunity.info/@api/deki/files/25541/adverser.xls?origin=mt-web

[Data Dictionary] https://semanticommunity.info/Data_Science/SAS_Public_Data_Sets#Sample_Data_4

[Unique ID Schema] There's one column named patient_id which specifies the identities of patients.
;
%let inputDataset3DSN = treatment;
%let inputDataset3URL =
https://github.com/yli110-stat697/team-2_project_repo/blob/master/data/treatment.xlsx?raw=true
;
%let inputDataset3Type = XLSX;


* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename
                tempfile
                "%sysfunc(getoption(work))/tempfile.&filetype."
            ;
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%macro loadDatasets;
    %do i = 1 %to 3;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets
