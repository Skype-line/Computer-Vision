% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%   
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)
    distances = ssd(descr1, descr2);
    
    if strcmp(matching, 'one-way')
        [~,I] = min(distances,[],2);
        matches = [1:size(descr1,2);I'];
    elseif strcmp(matching, 'mutual')
        [~,I1] = min(distances,[],2);
        matches = [1:size(descr1,2);I1'];
        [~,I2] = min(distances,[],1);
        mask = zeros(1,size(descr1,2));
        for i = 1:size(I1,1)
            if I2(I1(i))==i
                mask(i)=1 ;
            end
        end
        matches = matches(:,logical(mask));        
    elseif strcmp(matching, 'ratio')
        [~,I] = mink(distances,2,2);
        matches = [1:size(descr1,2);I'];
        mask = zeros(1,size(descr1,2));
        for i = 1:size(I,1)
            if distances(i,I(i,1))/distances(i,I(i,2)) < 0.5
                mask(i)=1 ;
            end
        end
        matches = matches(:,logical(mask));
    else
        error('Unknown matching type.');
    end
end

function distances = ssd(descr1, descr2)
    distances = pdist2(descr1',descr2','squaredeuclidean');
end