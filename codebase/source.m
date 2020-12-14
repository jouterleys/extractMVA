clear all
clc
fileName = 'C:\local_repos\github\mvaExtract\data\xk adidas ub 10.mva';
outputData = readMVAscan( fileName );
plotMVAraw (outputData)
[outputData.stance_start,outputData.stance_end] = MVAstance (outputData,1);