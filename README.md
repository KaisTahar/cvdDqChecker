# <p align="center"> CvdDqChecker: A Set of Metrics and Methods for Harmonized Quality Assessments on Cardiovascular Disease Data </p>

## 1. Description
This repository provides metrics and methods for data quality (DQ) assessment on cardiovascular disease (CVD) data. The developed software `CvdDqChecker`enables harmonized assessments and reporting on DQ issues that may arise in the context of CVDs. `CvdDqChecker` also provides features to detect and visualize DQ issues such as outliers and contradictions. The current version was validated using both synthetic data and real-world data on CVDs.
## 2. Local Execution
To conduct local DQ assessments, please follow the following instructions:

1. Clone repository and checkout master branch
   - Run the git command: ``` git clone --branch master https://github.com/KaisTahar/cvdDqChecker ```

2. Edit the file [`config.yaml`](https://github.com/KaisTahar/cvdDqChecker/blob/master/config.yaml) with your local variables (v1...v7)
   - Define your study name (v1) and organization name (v2) 
   - Set the data input path (v3). This variable specifies which data set should be imported. By default this path is set as follows:
     <br/>``` dataPath="./data/medData/syntheticData.csv" ```
   - Define the code list of missing data values (v4) else by default this variable is defined as follows:
     <br/>``` missingCode: !expr list ("",NA, "NULL")``` 
   - Set the path to the spreadsheet file containing the DQ rules (v5). By default, this path is set as follows:
     <br/>``` rulePath: "./data/refData/dqRules.xlsx"``` 
   - Set the path to the semantic annotations (v6). By default, this variable is set as follows:
     <br/>``` semanticPath: "./data/refData/semData.csv" ```
   - Specify the path to the resulting visualizations and DQ reports (v7). By default, the export path is set as follows:
     <br/>``` exportPath: "./data/export"```

3. Once the data path and local variables are defined, you can run `CvdDqChecker` using Rstudio or Dockerfile. To avoid local dependency issues,  simply execute the command ```sudo docker-compose up``` to get the software up and running

4. As a result,`CvdDqChecker` generates visualizations of detected outliers and contradictions, as well as an Excel file that contains reports on DQ metrics and detected DQ issues. These reports provide important information to help users identify the DQ issues and trace them back to their underlying causes, with the aim of enabling users to understand the DQ issues and their root reasons. The generated reports and plots are saved in the folder `./data/export`

## 3. DQ Metrics and Reports
The data quality library (dqLib) was employed as an R package to report on DQ issues and metrics. `dqLib` provides multiple metrics to assess different aspects of DQ. This library was used to select appropriate dimensions and indicators as well as to define specific DQ reports. The following generic indicators were employed in this study:

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

<br />  In addition to indicators, the DQ reports include the resulting parameters and adequate information to identify potential DQ issues. The developed software `CvdDqChecker` enables users to specify DQ rules using spreadsheets and to detect DQ issues based on predefined rules. `CvdDqChecker` provides functions to report on the following DQ issues:
  
  | Abbreviation | DQ Parameter | Description |
  |-----|--------------------------- | ------------|
  |  im_misg | missing mandatory data items |  number of missing mandatory data items|
  |  vm_misg | missing mandatory data values| number of missing mandatory data values|
  |  vo | outlier values | number of detected outlier values  |
  |  vc | contradictory values | number of detected contradictory data values  |

## 4. Examples

- Some examples of reports on detected outliers and contradictions can be found in the `./data/export` folder
- The [`./data/export`](https://github.com/KaisTahar/cvdDqChecker/tree/master/data/export) folder also contains exemplary visualizations generated using synthetic data

## 5. Notes

- The developed software `CvdDqChecker` is compatible with [`dqLib 1.32.0`](https://github.com/KaisTahar/dqLib/releases/tag/v1.32.0). To install all required packages, please use the script `installPackages.R` located in the folder `./R` or just run the command `sudo docker-compose up`. This command will install the necessary packages and run the DQ assessment software.

- To cite `CvdDqChecker`, please use the citation file `CITATION.cff`


