# 📦 Maximum-Entropy Estimator for City-Scale Pedestrian Movement

This repository contains the code for a proposed maximum-entropy estimator designed to infer city-scale pedestrian movement patterns using point-count data captured by sensor networks.

## 🚀Quick start

The estimator infers flow dynamics using the network structure matrix (A) and observed node counts (N). The core function my_estimate_p_newton_new handles this estimation.

### Inputs 
-  ``A`` (Binary Matrix): encodes the potential flows between sensors that remain to be estimated. If $A_{ij} = 1$, the flow from the $i$-th sensor to the $j$-th sensor is included in the estimation.
-  ``N`` (a vector): Encodes the pedestrian counts observed at each sensor during a specific time interval.

```
% A demo
A = [0 0 1; 0 0 1; 0 0 0 ]；% Avaliable links are: 1->3, 2->3
N = [2 3 4];
[P_M,O,D,flag_global,count_modified,error] = my_estimate_p_newton_new(A,N)
```
The output:
- ``P_M`` (Matrix): The transition probabilities between sensors. The estimated flow on link $i \to j$ is calculated as $N_i \times (P_M)_{ij}$.
- ``O``(Vector): Departure rates. The value $N_i \times O_i$ represents the estimated number of pedestrians directly leaving the system from place $i$. Equivalently, this is the portion of the count that departs without being detected by another sensor.
- ``D``(a vector): Arrival rates. The value $N_i \times D_i$ represents the estimated number of pedestrians arriving at place $i$. Equivalently, this is the portion of the count that arrived without prior detection.

## 🪶 Main features & assumpuions
* The Core Problem: Pedestrian counts (e.g., the number of people crossing a specific line on a road) are often collected sparsely around a city. Our goal is to infer global, city-scale movement trajectories from these localized observations.
* An Under-Determined System: Even as the number of sensors available to collect data increases, inferring exact dynamics from point counts remains an under-determined problem. This means there are multiple feasible movement systems that could align with the observed data.
* Maximum-Entropy Theory: To solve this without introducing biased assumptions, we use the ensemble average as an estimate to fully utilize the available information, grounded in the principle of maximum entropy.

## ⚠️The network ``A``
- Distance-Based Criterion: The matrix A dictates which sensor-to-sensor flows are mathematically possible. In our work, we use a distance-based criterion to create this network: if the geodesic distance between a pair of sensors is below a threshold $T$, a link is assumed to exist. We utilize a bootstrap method to validate this threshold.
- Real-World Context: In practice, determining the correct network structure requires extra effort and domain knowledge. This may involve spatial experiments or direct investigation into the physical transportation infrastructure (e.g., footpaths, crossings) actually available to pedestrians in the real world.

## 📁Repository Contents & Pipeline
- Datasets: We include three real-world datasets (Melbourne, Ulm, and Bristol) that support the findings reported in our associated article.
- Data Pipeline: While estimating the flows via the my_estimate_p_newton_new function is straightforward, a significant amount of effort has been paid to extract the abstract sensor networks based on raw sensor coordinates and complex road grids.
-Implementation: The complete pipeline for this extraction is included in Main_Manuscript_Template.m, alongside the detailed realizations for each system.
Note: Because it must account for real-world spatial constraints, the network extraction process is inherently complex.
