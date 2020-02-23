function [LocalA,Localb] = RetinexConstraint(I,chrom,threshold)
% If |chrom(p) - chrom(q)| > t, weight = 0, otherwise weight weight = WEIGHT;
% |(Sp-Sq)^2 + weight*(Rp-Rq)^2|     % Rp=Ip-Sp;
% |(1+weight)*(Sp-Sq)^2 - 2*weight*(Ip-Iq)*(Sp-Sq) + weight*(Ip-Iq)^2|
% (1/2)s'As - b's + c  EQU   As = b
% Reference:
% [1] Q.Zhao,P.Tan. A Closed-Form Solution to Retinex with Nonlocal Texture Constraints.
   
    WEIGHT = 1000;
    [h,w,~] = size(I);
    I = reshape(I,h*w,3);
    chrom = reshape(chrom,h*w,3);
    p_ori = reshape(1 : h*w, h, w);
    % 8 neighbors
    selfrow = 2:h-1;
    selfcol = 2:w-1;
        
    p_self = reshape( p_ori(selfrow, selfcol), [],1 );
    p_up = reshape( p_ori(selfrow-1, selfcol), [],1);
    p_down = reshape( p_ori(selfrow+1,selfcol), [],1);
    p_left = reshape( p_ori(selfrow, selfcol-1), [],1);
    p_right = reshape( p_ori(selfrow, selfcol+1), [],1);
    p_upleft = reshape( p_ori(selfrow-1, selfcol-1), [],1);
    p_upright = reshape( p_ori(selfrow-1, selfcol+1), [],1);
    p_downleft = reshape( p_ori(selfrow+1, selfcol-1), [],1);
    p_downright = reshape( p_ori(selfrow+1, selfcol+1), [],1);
    
    edge1 = repmat(p_self,8,1);
    edge2 = [p_up;p_down;p_left;p_right;p_upleft;p_upright;p_downleft;p_downright];
    edge = [edge1,edge2];
    edge = unique([min(edge(:,1),edge(:,2)) max(edge(:,1),edge(:,2))],'rows');%去掉重复的行
    npairs = size(edge,1);
%% compute weight  
    I_p = I(edge(:,1),:);
    I_q = I(edge(:,2),:);
    sub_I = log(max(sqrt(sum(I_p.^2,2)),0.0001))...
	      - log(max(sqrt(sum(I_q.^2,2)),0.0001)); 
   
    chrom_p = chrom(edge(:,1),:); 
    chrom_q = chrom(edge(:,2),:);
    sub_chrom = chrom_p - chrom_q;
    dChrom = sqrt(sum(sub_chrom.^2,2));
    idx = find(dChrom <= threshold);
    weight = zeros(npairs,1);
    weight(idx) = WEIGHT;    
    dweight = sub_I .* weight;
    weightA = weight + 1;
 
%% Form sparse matrix（h*w X h*w）
    LocalA = sparse(edge(:,1), edge(:,1), weightA, h*w, h*w)...
           - sparse(edge(:,1), edge(:,2), weightA, h*w, h*w)...
           + sparse(edge(:,2), edge(:,2), weightA, h*w, h*w)...
           - sparse(edge(:,2), edge(:,1), weightA, h*w, h*w);      
    Localb = sparse(edge(:,1), 1, dweight, h*w, 1)...
           - sparse(edge(:,2), 1, dweight, h*w, 1);
end