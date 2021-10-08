function Retinex = retinex_frankle_mccann(L, nIterations)

% RETINEX_FRANKLE_McCANN: 
%         Computes the raw Retinex output from an intensity image, based on the
%         original model described in:
%         Frankle, J. and McCann, J., "Method and Apparatus for Lightness Imaging"
%         US Patent #4,384,336, May 17, 1983
%
% INPUT:  L           - logarithmic single-channel intensity image to be processed
%         nIterations - number of Retinex iterations
%
% OUTPUT: Retinex     - raw Retinex output
%
% NOTES:  - The input image is assumed to be logarithmic and in the range [0..1]
%         - To obtain the retinex "sensation" prediction, a look-up-table needs to
%         be applied to the raw retinex output
%         - For colour images, apply the algorithm individually for each channel
%
% AUTHORS: Florian Ciurea, Brian Funt and John McCann. 
%          Code developed at Simon Fraser University.
%
% For information about the code see: Brian Funt, Florian Ciurea, and John McCann
% "Retinex in Matlab," by Proceedings of the IS&T/SID Eighth Color Imaging 
% Conference: Color Science, Systems and Applications, 2000, pp 112-121.
%
% paper available online at http://www.cs.sfu.ca/~colour/publications/IST-2000/
%
% Copyright 2000. Permission granted to use and copy the code for research and 
% educational purposes only.  Sale of the code is not permitted. The code may be 
% redistributed so long as the original source and authors are cited.

global RR IP OP NP Maximum
RR = L;
Maximum = max(L(:));                                 % maximum color value in the image
[nrows, ncols] = size(L);

shift = 2^(fix(log2(min(nrows, ncols)))-1);          % initial shift
OP = Maximum*ones(nrows, ncols);                     % initialize Old Product

while (abs(shift) >= 1)
   for i = 1:nIterations
      CompareWith(0, shift);                         % horizontal step
      CompareWith(shift, 0);                         % vertical step
   end
   shift = -shift/2;                                 % update the shift
end
Retinex = NP;

function CompareWith(s_row, s_col)
global RR IP OP NP Maximum
IP = OP;
if (s_row + s_col > 0)
   IP((s_row+1):end, (s_col+1):end) = OP(1:(end-s_row), 1:(end-s_col)) + ...
   RR((s_row+1):end, (s_col+1):end) - RR(1:(end-s_row), 1:(end-s_col));
else
   IP(1:(end+s_row), 1:(end+s_col)) = OP((1-s_row):end, (1-s_col):end) + ...
   RR(1:(end+s_row),1:(end+s_col)) - RR((1-s_row):end, (1-s_col):end);
end
IP(IP > Maximum) = Maximum;                          % The Reset operation
NP = (IP + OP)/2;                                    % average with the previous Old Product
OP = NP;                                             % get ready for the next comparison