# extractMVA

## Overview
The main features of this toolbox are to import and package Pedar data from *.mva files.
## Installation
Clone the git repository using git. Or, download a compressed copy [here](https://github.com/jouterleys/extractmva/archive/main.zip).
## How to use
1. Double click the extractMVA.m file from the extractMVA folder. This will open up MATLAB with the current directory being the extractMVA folder. If not change directory to the extractMVA folder (i.e. cd "path to extractMVA").
2. Type **extractMVA** in the MATLAB command window and hit enter to run.
3. Select file to analyze. Sample data is contained in the data.zip file (must be unzipped first).
## Outputs
The toolbox creates a matfile in the Workspace that contains all the information from .mva file. It also separates the segments contained in the .mva file and parses and normalises to stance phase.

## Time Normalised Data
Data is normalised to the longest stance phase in the data file. The length of stance when the sampling frequency is only 50 Hz is generally less that 20 frames, therefore interpolating to 101 points adds a lot of estimated data and creates issues at the edge points.
Normalised is most useful for ensemble averaging which can only be performed when all trials are the same length.
However, the .mean field within each metric (force, max pressure, etc.) for each segment is upsampled to 101 points for comparison to other data normalized to this length. A linear spline is used (MATLAB's defaults for interp1 is used.
Note: If discrete metrics are going to be extracted they should be done on the .raw fields.
