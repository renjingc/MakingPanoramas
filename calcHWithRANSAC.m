function H = calcHWithRANSAC(p1, p2)
% Returns the homography that maps p2 to p1 under RANSAC.
% Pre-conditions:
%     Both p1 and p2 are nx2 matrices where each row is a feature point.
%     p1(i, :) corresponds to p2(i, :) for i = 1, 2, ..., n
%     n >= 4
% Post-conditions:
%     Returns H, a 3 x 3 homography matrix

    assert(all(size(p1) == size(p2)));  % input matrices are of equal size
    assert(size(p1, 2) == 2);  % input matrices each have two columns
    assert(size(p1, 1) >= 4);  % input matrices each have at least 4 rows

    %------------- YOUR CODE STARTS HERE -----------------
    % 
    % The following code computes a homography matrix using all feature points
    % of p1 and p2. Modify it to compute a homography matrix using the inliers
    % of p1 and p2 as determined by RANSAC.
    %
    % Your implementation should use the helper function calcH in two
    % places - 1) finding the homography between four point-pairs within
    % the RANSAC loop, and 2) finding the homography between the inliers
    % after the RANSAC loop.
    
    numIter=100;
    maxDist=3;
    n=size(p1,1);
    inlrNum = zeros(1,numIter);
    finlier1=cell(1,numIter);
    numPoints=4;
    for i=1:numIter
        index = zeros(1,numPoints);
        available = 1:n;
        rs = ceil(rand(1,numPoints).*(n:-1:n-numPoints+1));
        for p = 1:numPoints
            while rs(p) == 0
                rs(p) = ceil(rand(1)*(n-p+1));
            end
            index(p) = available(rs(p));
            available(rs(p)) = [];
        end
        H = calcH(p1(index,:), p2(index,:));
        dist=calcDist(H,p1',p2');
        
        finlier1{i}= find(dist < maxDist);
        inlrNum(i) = length(finlier1{i});
    end

    [~,idx] = max(inlrNum);
    inlier=finlier1{idx};
    H = calcH(p1(inlier,:),p2(inlier,:));
	
    %H = calcH(p1, p2)

    %------------- YOUR CODE ENDS HERE -----------------
end

% The following function has been implemented for you.
% DO NOT MODIFY THE FOLLOWING FUNCTION
function H = calcH(p1, p2)
% Returns the homography that maps p2 to p1 in the least squares sense
% Pre-conditions:
%     Both p1 and p2 are nx2 matrices where each row is a feature point.
%     p1(i, :) corresponds to p2(i, :) for i = 1, 2, ..., n
%     n >= 4
% Post-conditions:
%     Returns H, a 3 x 3 homography matrix
    
    assert(all(size(p1) == size(p2)));
    assert(size(p1, 2) == 2);
    
    n = size(p1, 1);
    if n < 4
        error('Not enough points');
    end
    H = zeros(3, 3);  % Homography matrix to be returned

    A = zeros(n*3,9);
    b = zeros(n*3,1);
    for i=1:n
        A(3*(i-1)+1,1:3) = [p2(i,:),1];
        A(3*(i-1)+2,4:6) = [p2(i,:),1];
        A(3*(i-1)+3,7:9) = [p2(i,:),1];
        b(3*(i-1)+1:3*(i-1)+3) = [p1(i,:),1];
    end
    x = (A\b)';
    H = [x(1:3); x(4:6); x(7:9)];

end


function dist = calcDist(H,p1,p2)
    n = size(p1,2);
    p3 = H*[p2;ones(1,n)];
    p3 = p3(1:2,:)./repmat(p3(3,:),2,1);
    dist = sum((p1-p3).^2,1);
end