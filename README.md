# <p align="center"> CvdDqChecker: A Software Solution for Traceable and Explainable Assessments of Cardiovascular Disease Data Quality </p>

## 1. Description
This repository provides a set of metrics and harmonized methods for assessing the quality of cardiovascular disease (CVD) data. The developed software `CvdDqChecker` enables traceable and explainable data quality (DQ) assessments. Specifically, the generated reports provide detailed information to explain the detected DQ issues and help users trace them back to their sources and underlying causes. `CvdDqChecker` also enables the detection and visualization of plausibility issues based on predefined logical and mathematical rules. To improve usability, `CvdDqChecker` allows users to specify the DQ rules using spreadsheets. The current version was validated using synthetic and real-world data on CVDs. Exemplary DQ reports and visualizations are available in section 4.

## 2. Local Execution
To conduct local DQ assessments, please follow the following instructions:

1. Clone repository and checkout master branch
   - Run the git command: ``` git clone --branch master https://github.com/KaisTahar/cvdDqChecker ```

2. Edit the file [`config.yaml`](https://github.com/KaisTahar/cvdDqChecker/blob/master/config.yaml) with your local configuration parameters (p1...p7)
   - Define your study name (p1) and organization name (p2) 
   - Set the data input path (p3). This parameter specifies which data set should be imported. By default, this path is set as follows:
     <br/>``` dataPath="./data/medData/syntheticData.csv" ```
   - Define the code list of missing data values (p4) else by default this parameter is defined as follows:
     <br/>``` missingCode: !expr list (NA, "NULL", "")``` 
   - Set the path to the spreadsheet file containing the DQ rules (p5). By default, this path is set as follows:
     <br/>``` rulePath: "./data/refData/dqRules.xlsx"``` 
   - Set the path to the semantic annotations (p6). By default, this parameter is set as follows:
     <br/>``` semanticPath: "./data/refData/semData.csv" ```
   - Specify the path to the resulting visualizations and DQ reports (p7). By default, the export path is set as follows:
     <br/>``` exportPath: "./data/export"```

3. Once the local configuration parameters are defined, you can run `CvdDqChecker` using Rstudio or Dockerfile. To avoid local dependency issues,  simply execute the command ```sudo docker-compose up``` to get the software up and running

4. As a result,`CvdDqChecker` generates visualizations of detected outliers and contradictions, as well as an Excel file that contains reports on DQ metrics, detected DQ issues, and used DQ rules. The generated visualizations and DQ reports are saved in the folder `./data/export`

## 3. DQ Metrics and Reports
The data quality library (dqLib) was employed as an R package to report on DQ issues and metrics. `dqLib` provides multiple metrics to assess different DQ aspects. This library was used to select appropriate indicators and generate specific DQ reports. The following generic indicators were employed in this study:

<br />
<table>
    <thead>
        <tr>
            <th colspan="2">DQ Indicator </th>
            <th rowspan=2>DQ Dimension</th>
        </tr>
       <tr>
            <th>Abbreviation </th>
            <th>Name </th>
       </tr>
    </thead>
    <tbody>
        <tr>
            <td>dqi_co_icr</td>
            <td >Item Completeness Rate</td>
            <td rowspan=2>completeness</td>
        </tr>
        <tr>
            <td>dqi_co_vcr</td>
            <td>Value Completeness Rate</td>
        </tr>
        <tr>
            <td>dqi_pl_rpr</td>
           <td > Range Plausibility Rate </td>
           <td rowspan=2>Plausibility</td>
        </tr>
            <td>dqi_pl_spr</td>
           <td > Semantic Plausibility Rate </td>
        </tr>
    </tbody>
</table>

<br />  In addition to DQ indicators, the reports include the resulting DQ parameters and provide adequate information to help users address the detected DQ issues. `CvdDqChecker` enables reporting on the following DQ issues and associated parameters:
  
  | Abbreviation | DQ Parameter | Description |
  |-----|--------------------------- | ------------|
  |  vo | outlier values | number of detected outlier values  |
  |  vc | contradictory values | number of detected contradictory data values  |
  |  im_misg | missing mandatory data items |  number of missing mandatory data items|
  |  vm_misg | missing mandatory data values| number of missing mandatory data values|
  | pat_dq_iss | patient records with DQ issues| number of patient records with DQ issues|

## 4. Examples

- Exemplary reports on detected outliers and contradictions can be found in the `./data/export` folder
- The [`./data/export`](https://github.com/KaisTahar/cvdDqChecker/tree/master/data/export) folder also contains exemplary visualizations generated using synthetic data

## 5. Notes

- The developed software `CvdDqChecker` is compatible with [`dqLib 1.32.0`](https://github.com/KaisTahar/dqLib/releases/tag/v1.32.0). To install all required packages, please use the script `installPackages.R` located in the folder `./R` or just run the command `sudo docker-compose up`. This command will install the necessary packages and run the DQ assessment software.

- To cite `CvdDqChecker`, please use the citation file `CITATION.cff`


