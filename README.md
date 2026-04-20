# 📦 Maximum-entropy Estimator for city-scale pedestrian movement

The repository encloses code for the proposed maximum-entropy estimator for estimating city-scale pedestrian movement from counts captured by sensor networks. 

## 🚀Quick start
- The estimator takes the network structures ``A`` and the counts ``N`` observed at places as inputs.
- The function ``my_estimate_p_newton_new`` estimate the flow information given the network structures and the counts.
### Input 
-  ``A`` (a 0-1 matrix) encodes the information about the flows between sensors that reamins to be estimated. A_{ij}=1: the flows between i-th and j-th sensors are remained to be estimated).
-  ``N`` (a vector) encodes the counts observed at sensors during a given time interval.

```
% A demo
A = [0 0 1; 0 0 1; 0 0 0 ]；% Avaliable links are: 1->3, 2->3
N = [2 3 4];
[P_M,O,D,flag_global,count_modified,error] = my_estimate_p_newton_new(A,N)
```
The output:
- ``P_M`` (a matrix): transition probability between sensors. E.g., the esitimated flow on the link ij is N_i*(P_M)_{ij};
- ``O``(a vector): departure rates. E.g., N_i*O_i is the estimated pedestrian numbers that are thought to be directly leaving a place. Equivalently, this means the portion of counts has not been observed before being detected by the sensor i.
- ``D``(a vector): arriving rates. E.g., N_i*D_i is the estimated pedestrian numbers that are thought to be arriving at a place. Equivalently, this means the portion of counts has not been observed after being detected by the sensor i.

## 🪶 Main features / assumpuions
* We study a problem that if the pedestrian counts (i.e., the amount of pedestrians that passes certain places, for example, a line on the road) are collected around the city. How can we infer city-scale pedestrian movement from such information.
* While the information avaiable increase with the sensor available to collect counts, inferring dynamics from counts remains an *under-dertermined problem*, which means many feasible system aligining with the observation.
* We therefore using the ensemble average as an estimate for fully ultilizing the information. That is the maximum entropy theory.

## ⚠️The network ``A``
- The network encodes the information about the flows between sensors that reamins to be estimated. In our work, we use the distance-based criterion to create the network, if the geodesic distance between sensor pairs is below a threshold T, links are assumed to exist between this. We further use a bootstrape method to validate this threshold T.
- In practice, determing this network structure needs extra effort, those could possibly include experiments or investigation on the transportation facilities that pedestrians can use in the real-world systems.

## 📁Other content
- In the repository we include three real-world datasets which support the results we report in the article.
- While finding estimatie is easy via calling function ``my_estimate_p_newton_new``, a lot of efforts have been parid to extract the abstruct sensor networks based on the locations of sensors and the road networks. The pipeline for this is included in ``Main_Manuscript_Templete.m`` along with the detailed realization in each systems (Melbourne, Ulm and Bristol). Warning: the whole process is very complicated. 
