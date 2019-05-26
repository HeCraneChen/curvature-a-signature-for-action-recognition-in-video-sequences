function df = df_vect(k, x, f, Nr)
% Same as df_array, but for 1-D vectors, i.e. 1 x T or T x 1 arrays.


sz0 = size(f);
if size(f, 1) > size(f, 2) 
    f = f.';
end


df = zeros(size(f));

for j = 1:Nr
    df(:, j) = sum(fdcoeffF(k, x(j), x(1:Nr+j)).*f(:, 1:Nr+j), 2);
end

for i = Nr+1:sz0(dim)-Nr
    df(:, i) = sum(fdcoeffF(k, x(i), x(i-Nr:i+Nr)).*f(:, i-Nr:i+Nr), 2);
end

for j = sz0(dim) + 1 - Nr:sz0(dim)
df(:, j) = sum(fdcoeffF(k, x(j), x(j-Nr: end)).*f(:, j-Nr: end), 2); 
end


if size(f, 1) > size(f, 2)
    df = df.';
end