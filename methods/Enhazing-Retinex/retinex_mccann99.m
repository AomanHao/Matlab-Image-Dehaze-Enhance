function Retinex = retinex_mccann99(L, nIterations)


global OPE RRE Maximum 
[nrows ncols] = size(L) ;                              % get size of the input image 
nLayers = ComputeLayers(nrows, ncols) ;                % compute the number of pyramid layers 
nrows = nrows/( 2 ^nLayers) ;                            % size of image to process for layer 0 
ncols = ncols/( 2 ^nLayers) ; 
if (nrows*ncols > 25 )                                % not processing images of area > 25 
  error( ' invalid image size. ' )                       % at first layer 
end 
Maximum = max(L(:)) ;                                  % maximum color value in the image 
OP = Maximum*ones([nrows ncols]) ;                     % initialize Old Product 
for layer = 0 :nLayers 
   RR = ImageDownResolution(L, 2 ^(nLayers-layer)) ;    % reduce input to required layer size 
   
   OPE = [zeros(nrows, 1 ) OP zeros(nrows, 1 )] ;          % pad OP with additional columns
   OPE = [zeros( 1 ,ncols+ 2 ) ; OPE; zeros(1,ncols+2)];  % and rows 
   RRE = [RR(:, 1 ) RR RR(:,end)] ;                      % pad RR with additional columns 
   RRE = [RRE( 1 ,:) ; RRE; RRE(end,:)];                % and rows 
   
   for iter = 1 :nIterations 
     CompareWithNeighbor(- 1 , 0 ) ;                      % North 
     CompareWithNeighbor(- 1 , 1 ) ;                      % North-East 
     CompareWithNeighbor( 0 , 1 ) ;                       % East 
     CompareWithNeighbor( 1 , 1 ) ;                       % South-East 
     CompareWithNeighbor( 1 , 0 ) ;                       % South 
     CompareWithNeighbor( 1 , - 1 ) ;                      % South-West 
     CompareWithNeighbor( 0 , - 1 ) ;                      % West 
     CompareWithNeighbor(- 1 , - 1 ) ;                     % North-West 
   end 
   NP = OPE( 2 :(end- 1 ), 2 :(end- 1 )) ; 
   OP = NP(:, [fix( 1 : 0 . 5 :ncols) ncols]) ;              %%% these two lines are equivalent with 
   OP = OP([fix( 1 : 0 . 5 :nrows) nrows], :) ;              %%% OP = imresize(NP, 2) if using Image 
   nrows = 2 *nrows ; ncols = 2*ncols;                 % Processing Toolbox in MATLAB 
end 
Retinex = NP ; 

function CompareWithNeighbor(dif_row, dif_col) 
global OPE RRE Maximum 
% Ratio-Product operation 
IP = OPE( 2 + dif_row: (end- 1 +dif_row), 2 + dif_col: (end- 1 +dif_col)) + ... 
     RRE( 2 :(end- 1 ), 2 :(end- 1 )) - RRE( 2 + dif_row: (end- 1 +dif_row), 2 + dif_col: (end- 1 +dif_col)) ; 
     
IP(IP > Maximum) = Maximum ;                           % The Reset step 

% ignore the results obtained in the rows or columns for which the neighbors are undefined 
if (dif_col == - 1 ) IP(:, 1 ) = OPE( 2 :(end- 1 ), 2 ) ; end 
if (dif_col == + 1 ) IP(:,end) = OPE( 2 :(end- 1 ),end- 1 ) ; end 
if (dif_row == - 1 ) IP( 1 ,:) = OPE( 2 , 2 :(end- 1 )) ; end 
if (dif_row == + 1 ) IP(end,:) = OPE(end- 1 , 2 :(end- 1 )) ; end 
NP = (OPE( 2 :(end- 1 ), 2 :(end- 1 )) + IP)/ 2 ;               % The Averaging operation 
OPE( 2 :(end- 1 ), 2 :(end- 1 )) = NP ; 

function Layers = ComputeLayers(nrows, ncols) 
power = 2 ^fix(log2(gcd(nrows, ncols))) ;               % start from the Greatest Common Divisor 
while(power > 1 & ((rem(nrows, power) ~= 0 ) | (rem(ncols, power) ~= 0 ))) 
   power = power/ 2 ;                                   % and find the greatest common divisor 
end                                                  % that is a power of 2 
Layers = log2(power) ; 

function Result = ImageDownResolution(A, blocksize) 
[rows, cols] = size(A) ;                               % the input matrix A is viewed as 
result_rows = rows/blocksize ;                         % a series of square blocks 
result_cols = cols/blocksize ;                         % of size = blocksize 
Result = zeros([result_rows result_cols]) ; 
for crt_row = 1 :result_rows                          % then each pixel is computed as 
   for crt_col = 1 :result_cols                       % the average of each such block 
      Result(crt_row, crt_col) = mean2(A( 1 +(crt_row- 1 )* blocksize: crt_row*blocksize, ... 
                                       1 +(crt_col- 1 )* blocksize: crt_col*blocksize)) ; 
   end 
en