# cvdDqChecker: A Set of Metrics and Methods for Harmonized Quality Assessments on Cardiovascular Disease Data

This repository provides metrics and methods for data quality (DQ) assessment on cardiovascular disease (CVD) data. The developed software `cvdDqChecker`enables harmonized assessments and reporting on DQ issues that may arise in the context of CVDs. `cvdDqChecker` also provides features to detect and visualize DQ issues such as outliers and contradictions. The current version was validated using both synthetic data and real-world data on CVDs.

## DQ Metrics and Reports
The data quality library (dqLib) was employed as an R package to report on DQ issues and metrics. `dqLib` provides multiple metrics to assess different aspects of DQ. This library was used to select desired dimensions and indicators as well as to define specific DQ reports. The following generic indicators were employed in this study:

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


## Note

- The developed software `cvdDqChecker` is compatible with [`dqLib 1.32.0`](https://github.com/KaisTahar/dqLib/releases/tag/v1.32.0). To install all required packages, please use the script `installPackages.R` located in the folder `./R` or just run the command `sudo docker-compose up`. This command will install the necessary packages and run the DQ assessment software.

- To cite `cvdDqChecker`, please use the citation file `CITATION.cff`

