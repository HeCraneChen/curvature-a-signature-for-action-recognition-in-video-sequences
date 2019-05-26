% Tommy Mitchel, 2018 tmitchel@jhu.edu
% Uses high order finite difference method to compute numerical derivatives
% along arbitrary dimension of an array
% Uses Frohnberg's method to compute coefficents

function df = df_array(k, x, f, Nr, dim)

%k: order of the derivative you want to take. If you want to compute the
%first derivative, k = 1, the second derivative, k = 2, etc. 
%x: elements in domain of known function values, should be a 1-D array
%f: known function values, f(x), i.e. your input array
%Nr: About half of your window size, i.e. how many points in front and
%behind you want to consider when computing the derivaitve. This value can
%vary based on how finely sampled your data is, however Nr = 3 or Nr = 4
%usually works well
%dim: the dimension you want to derive along (usually your temporal or
%spatial dimension)


sz0 = size(f);
f = reshape(f, [prod(sz0)/sz0(dim), sz0(dim)]); %this reshape is not necessary when f is already 2D matrix, it's originally meant for the case that f is 3D matrix

df = zeros(size(f));

for j = 1:Nr
    df(:, j) = sum(fdcoeffF(k, x(j), x(1:Nr+j)).*f(:, 1:Nr+j), 2);
end

for i = Nr+1:sz0(dim)-Nr
    df(:, i) = sum(fdcoeffF(k, x(i), x(i-Nr:i+Nr)).*f(:, i-Nr:i+Nr), 2);
end

for j = sz0(dim) + 1 - Nr:sz0(dim)
    a=fdcoeffF(k, x(j), x(j-Nr: end));
    b=f(:, j-Nr: end);
df(:, j) = sum(fdcoeffF(k, x(j), x(j-Nr: end)).*f(:, j-Nr: end), 2); 
end

 df = reshape(df, sz0);

