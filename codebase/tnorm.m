function tnDat = tnorm(inDat,npts,type)

% Scripts Developed by Jereme Outerleys, April 2020


%   Copyright (c) <2020> <Jereme Outerleys>
%   Licensed under the MIT License. See LICENSE in the project
%   root for license information.

[nframes, ncols] = size(inDat);
x1 = (1:nframes)';
x2 = (linspace(1, nframes, npts))';

if strcmp(type, 'linear')
    for i=1:ncols       
        tnDat(:,i)=interp1(x1,inDat(:,i),x2)';
    end
elseif strcmp(type, 'cubic')
    for i=1:ncols
        tnDat(:,i)=spline(x1,inDat(:,i),x2)';        
    end
end