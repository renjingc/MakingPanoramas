function [ im_blended ] = blend( im_input1, im_input2 )
%BLEND Blends two images together via feathering
% Pre-conditions:
%     `im_input1` and `im_input2` are both RGB images of the same size
%     and data type
% Post-conditions:
%     `im_blended` has the same size and data type as the input images
    
    assert(all(size(im_input1) == size(im_input2)));
    assert(size(im_input1, 3) == 3);

    im_blended = zeros(size(im_input1), 'like', im_input1);
    
    %------------- YOUR CODE STARTS HERE -----------------
    im_input1(isnan(im_input1))=0;
    im_input2(isnan(im_input2))=0;
    
    im_alpha1=rgb2alpha(im_input1);
    im_alpha2=rgb2alpha(im_input2);

    rows=size(im_input1,1);
    cols=size(im_input1,2);
    for i=1:rows
       for j=1:cols
            if (im_input1(i,j,1)>0||im_input1(i,j,2)>0||im_input1(i,j,3)>0) &&(im_input2(i,j,1)>0||im_input2(i,j,2)>0||im_input2(i,j,3)>0) 
                if im_alpha1(i,j)==0&&im_alpha2(i,j)==0
                    im_blended(i,j,1)=0;
                    im_blended(i,j,2)=0;
                    im_blended(i,j,3)=0;
                end
                im_blended(i,j,1)=(im_alpha1(i,j)*im_input1(i,j,1)+im_alpha2(i,j)*im_input2(i,j,1))/(im_alpha1(i,j)+im_alpha2(i,j)); 
                im_blended(i,j,2)=(im_alpha1(i,j)*im_input1(i,j,2)+im_alpha2(i,j)*im_input2(i,j,2))/(im_alpha1(i,j)+im_alpha2(i,j)); 
                im_blended(i,j,3)=(im_alpha1(i,j)*im_input1(i,j,3)+im_alpha2(i,j)*im_input2(i,j,3))/(im_alpha1(i,j)+im_alpha2(i,j));
            elseif im_input1(i,j,1)>0||im_input1(i,j,2)>0||im_input1(i,j,3)>0
                im_blended(i,j,1)=im_input1(i,j,1);
                im_blended(i,j,2)=im_input1(i,j,2);
                im_blended(i,j,3)=im_input1(i,j,3);
            elseif im_input2(i,j,1)>0||im_input2(i,j,2)>0||im_input2(i,j,3)>0
                im_blended(i,j,1)=im_input2(i,j,1);
                im_blended(i,j,2)=im_input2(i,j,2);
                im_blended(i,j,3)=im_input2(i,j,3);
            else
                im_blended(i,j,1)=0;
                im_blended(i,j,2)=0;
                im_blended(i,j,3)=0;
            end
       end
    end
    %------------- YOUR CODE ENDS HERE -----------------

end

function im_alpha = rgb2alpha(im_input, epsilon)
% Returns the alpha channel of an RGB image.
% Pre-conditions:
%     im_input is an RGB image.
% Post-conditions:
%     im_alpha has the same size as im_input. Its intensity is between
%     epsilon and 1, inclusive.

    if nargin < 2
        epsilon = 0.001;
    end

    %------------- YOUR CODE STARTS HERE -----------------
    I=rgb2gray(im_input); 
    F=I<epsilon;%front  
    im_alpha=bwdist(F,'euclidean');  
    
    %------------- YOUR CODE ENDS HERE -----------------

end
