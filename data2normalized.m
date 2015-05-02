function normalizedPosition = data2normalized( axesHandle, position) 
% NORMALIZEDPOSITION returns the normalized position based on the position 
% in the data space 
% Input: 
%   axesHandle: the handle of the axes 
%   position: [x, y, w, h] of the position in data space
%
% Output:
%   noramlizedPosition: the output 
% 
% Wei Shang 
% wei.shang@unb.ca 

pos = get(axesHandle, 'position'); 
xn = pos(1); yn = pos(2); 
wn = pos(3); hn = pos(4); 

% getting the data boundaries of the original plot 
xd  = get(axesHandle, 'xlim'); yd  = get(axesHandle, 'ylim');
wd   = xd(2) - xd(1);  hd  = yd(2) - yd(1);


% calculate the ratio between the data unit to the normalized unit. 
x_n2d = wd / wn; 
y_n2d = hd / hn;

% Read in the position vector of the zoom-in plot based on data boundary 
tx1 = position(1); 
ty1 = position(2); 

% compute the corresponding position vector based on the normalized unit 
normalizedPosition(1) = (tx1 - xd(1)) / x_n2d + xn;
normalizedPosition(2) = (ty1 - yd(1)) / y_n2d + yn; 
normalizedPosition(3) = position(3) / x_n2d ;
normalizedPosition(4) = position(4) / y_n2d ;