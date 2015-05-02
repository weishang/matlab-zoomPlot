function [sourceRect, targetAxes] = addZoomInAxes( axesHandle )
% ADDZOOMINAXES adds in an axes that 'zoom-in' to a portion of the existing axes
%

figureHandle = get(axesHandle, 'parent' );

allChildrenOjbects = allchild(axesHandle)

% prompt the user to select an area in the current axes
msgbox('Select the source area to zoom in', 'Source area selection', 'modal');

% focus on the current figure
figure( figureHandle );

% trigger the rect drawing tool
sourceRect = imrect( axesHandle );


position = getPosition( sourceRect);

rectHandle = rectangle('Position',position, 'EdgeColor', 'r');

uistack(rectHandle, 'bottom');

    function updateSourceRect (pos)
        % things to update if the position of the source rectangle is updated 
        
        % first of all, the content of the target axes 
        
        set(rectHandle, 'position', pos);
        % rectHandle = rectangle('Position',position, 'EdgeColor', 'r');
        
    end

addNewPositionCallback(sourceRect,  @updateSourceRect  ) ;



% prompt to draw another box
 msgbox('Select an area to place the zoom plot', 'Target area selection', 'modal');

% trigger the rect drawing tool
targetRect = imrect( axesHandle ) ;

normalizedPosition = data2normalized( axesHandle, getPosition(targetRect)) 




az = axes('position', normalizedPosition);

copyobj(allChildrenOjbects, az);

set(az, 'xtick', [], 'ytick', []);
% set(source_rect, 'linestyle','--', 'Edgecolor', 'k');
box on;


uistack(axesHandle, 'bottom');
% super impose the axes to cover the existing rect

end
